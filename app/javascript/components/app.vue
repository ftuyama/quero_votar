<script>
  import Menu from '../components/menu.vue';
  import Header from '../components/header.vue';

  export default {
    components: {
      'nav-menu': Menu,
      'nav-header': Header,
    },
    data: function () {
      return {
        message: "Welcome to Cinematronix!"
      }
    }
  }
</script>

<style scoped>
  .el-header, .el-footer {
    background-color: #B3C0D1;
    color: #333;
    text-align: center;
    line-height: 60px;
    padding: 0;
  }
  
  .el-aside {
    background-color: #2A353B;
    color: #333;
    text-align: center;
    line-height: 200px;
  }

  .el-container {
    height: 100%;
  }

  .el-aside {
    box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
  }
  
  .el-main {
    background-color: #E9EEF3;
    color: #333;
    text-align: center;
    line-height: 160px;
  }

  #app {
    background-color: #E9EEF3;
    bottom: 0;
    top: 0;
    left: 0;
    right: 0;
    position: absolute;
  }
  
  .el-container:nth-child(5) .el-aside,
  .el-container:nth-child(6) .el-aside {
    line-height: 260px;
  }
  
  .el-container:nth-child(7) .el-aside {
    line-height: 320px;
  }

  .box {
    margin: 40px;
    background: #FFF;
    box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
  }

  .content {
    width: 100%;
    margin: 40px;
  }
</style>

<template>
  <div id='app'>
    <el-container>
      <el-aside>
        <nav-menu></nav-menu>
      </el-aside>
      <el-container>
        <el-header>
          <nav-header></nav-header>
        </el-header>
        <el-main>
          <el-container class="box">
            <div class="content">
              <router-view></router-view>
            </div>
          </el-container>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>
