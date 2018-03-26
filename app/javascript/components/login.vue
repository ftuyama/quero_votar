<script>
  import SlackButton from '../components/slack_button.vue';

  export default {
    components: {
      'slack-button': SlackButton,
    },
    data: function () {
      return {
        message: "Welcome to Cinematronix!"
      }
    }
  }
</script>

<style scoped>
  .title {
    font-size: 2em;
    font-weight: 500;
    text-align: center;
    line-height: 3;
    margin-top: 0;
  }

  .el-container {
    justify-content: center;
  }
</style>

<template>
  <div>  
    <h2 class="title">Bem-vindo ao Quero Votar!</h2>
    <el-container>
      <slack-button></slack-button>
    </el-container> 
  </div>
</template>
