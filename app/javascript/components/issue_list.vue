<script>
  export default {
    data() {
      return {
        newData: this.fetchData(),
        tableData: [{
          date: '2016-05-03',
          name: 'Tom',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          date: '2016-05-02',
          name: 'Tom',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          date: '2016-05-04',
          name: 'Tom',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          date: '2016-05-01',
          name: 'Tom',
          address: 'No. 189, Grove St, Los Angeles'
        }]
      }
    },
    methods: {
      fetchData() {
        websocket.trigger('topic.list', {}, function(data) {
          console.log('successfully created ' + JSON.stringify(data));
          console.log(JSON.stringify(this.tableData));
          this.tableData = data;
          console.log(JSON.stringify(this.tableData));
        });
      }
    }
  }
</script>

 <template>
  <el-table
    :data="tableData"
    style="width: 100%">
    <el-table-column
      prop="created_at"
      label="Date"
      width="180">
    </el-table-column>
    <el-table-column
      prop="name"
      label="Name"
      width="180">
    </el-table-column>
    <el-table-column
      prop="description"
      label="Address">
    </el-table-column>
  </el-table>
</template>
