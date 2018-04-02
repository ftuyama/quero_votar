node {
    def app
    def workspacePath = pwd()
    def pgContainer
    def pgHostPort
    def pgHostname = "postgres-$BUILD_TAG"
    def rng = new Random(0x1337B01)
    def network = "quero-votar__services"
    def containerArgs = [
        "-v ${workspacePath}/cache/.bundler:/root/.bundler:Z",
        "-v ${workspacePath}/cache/.yarn-cache:/root/.yarn-cache:Z",
        "-u root",
        "--network=${network}",
        "-e DB_HOST=${pgHostname}",
        "-e DB_USER=postgres"
    ].join(" ")

    try {
        stage("Checking out code") {
            /* checkout([
                $class: 'GitSCM',
                branches: [[name: "${GITHUB_BRANCH_NAME}",
                            credentialsId: "21e329ec-2aec-4bf6-a923-6a2e1b5f0e8c"]],
                userRemoteConfigs: [[url: "git@github.com:redealumni/quero_votar.git"]],
                doGenerateSubmoduleConfigurations: false,
                extensions: [],
            ]) */
            git([
                    branch: "${GITHUB_PR_SOURCE_BRANCH}",
                    credentialsId: "21e329ec-2aec-4bf6-a923-6a2e1b5f0e8c",
                    url: "git@github.com:redealumni/quero_votar.git"
                ])
            updateGithub("pending", "Build is RUNNING")

        }

        stage("Building app docker image") {
            def gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            app = docker.build("quero_votar", "--file Jenkins.dockerfile --build-arg QUERO_VOTAR_GIT_REVISION=${gitCommit} .")
        }

        stage("Creating ${network} network") {
            try {
                sh "docker network create -d bridge ${network}"
            }
            catch(err) {
                sh "echo 'Network already created!'"
            }
        }

        stage("Spawn postgres container") {
            pgContainer = sh(returnStdout: true, script: "docker run -d --network=${network} -P -u root --name=${pgHostname} postgres:9.4").trim()
            pgHostPort  = sh(returnStdout: true, script: "docker inspect ${pgContainer} | grep HostPort | sort | uniq | grep -o [0-9]*").trim()
        }

        stage("Building testing environment") {
            app.inside(containerArgs) {
                sh "bundle install"
                sh "yarn install"
            }
        }

        stage("Preparing test suite") {
            app.inside(containerArgs) {
                sh "bundle exec rake db:create"
                sh "bundle exec rake db:migrate"
                sh "bundle exec rake seed:migrate"
                sh "rm junit-test-results*.xml"
            }
        }

        stage("Running test suite") {
            def testFiles = findFiles(glob: "spec/**/*_spec.rb").toList()
            Collections.shuffle(testFiles, rng)

            def concurrentTests = 1
            def groupSize = divAndCeil(testFiles.size(), concurrentTests)
            def groupedFiles = testFiles.collate(groupSize)
            def testGroups = [:]

            for(int i = 0; i < groupedFiles.size(); i++) {
                def selectedFiles = groupedFiles[i].collect({ it.path }).join(' ')
                def idx = i // Closure shit

                testGroups["split-${idx}"] = {
                    app.inside(containerArgs) {
                        timeout(time: 3, unit: 'MINUTES') {
                            sh script: ["JENKINS_TEST_REPORT_POSTFIX=${idx}",
                                        "bundle exec rspec ${selectedFiles}",
                                        "--format RspecJunitFormatter",
                                        "--out junit-test-results-${idx}.xml"].join(" "),
                            returnStatus: true
                        }
                    }
                }
            }

            parallel testGroups
        }

        stage("Collect all test data") {
            app.inside(containerArgs) {
                sh "bundle exec ruby lib/concatenate_tests.rb junit-test-results-*.xml > junit-test-results.xml"
                junit "junit-test-results.xml"
            }
        }
        stage("Update Github status") {
            if (fileExists('tests_failed')) {
                updateGithub("failure", "Some tests FAILED")
            }
            else {
                updateGithub("success", "All tests PASSED")
            }
        }
    }
    catch (Exception e) {
        stage("Error") {
            updateGithub("error", "Some ERROR occurred")
        }
    }
    finally {
        stage("Tear down postgres instance") {
            sh "docker stop ${pgHostname}"
        }
    }
}

Integer divAndCeil(Number dividend, Number divisor) {
    return (dividend+divisor-1).intdiv(divisor)
}

void updateGithub(String status, String description) {
    payload = """
{
  "state": "${status}",
  "target_url": "http://ci.lan.querobolsa.space:48080/job/${JOB_BASE_NAME}/${BUILD_NUMBER}",
  "description": "${description}",
  "context": "CI.lan"
}
"""
    httpRequest([
            acceptType: 'APPLICATION_JSON',
            contentType: 'APPLICATION_JSON',
            httpMode: 'POST',
            requestBody: payload,
            customHeaders: [[name: 'Authorization', value: 'token bcce25fe91f0ac6f3ac5063fa62d37cb1bd9dd37']],
            url: "https://api.github.com/repos/redealumni/quero_votar/statuses/${GITHUB_PR_HEAD_SHA}"
])
    println "updateGithub ${status} ${description}"
}
