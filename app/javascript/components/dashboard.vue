<script>
  import IssueList from '../components/issue_list.vue';

  export default {
    components: {
      'issue-list': IssueList,
    },
    data: function () {
      return {
        message: "Bem vindo ao Quero Votar!"
      }
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }

  .title {
    font-size: 2em;
    font-weight: 500;
    text-align: center;
    line-height: 3;
    margin-top: 0;
  }
</style>

<template>
  <div>
    <p>{{ message }}</p>

    <div>
      <issue-list></issue-list>
    </div>

    <el-button>Votar</el-button>
  </div>
</template>
