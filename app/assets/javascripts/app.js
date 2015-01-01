var test = angular.module('test', [ 'ngMaterial', 'angular-dimple' ]);



test.controller('Summarizer', ['$scope', '$http', function($scope, $http){

  $scope.getSkillSummary = function() {
    $http.get('/summary/' + $scope.skill).
      success(function(data, status, headers, config) {
        console.log(data);
        console.log(data.total_jobs);
        $scope.summary = data;
      }).
      error(function(data, status, headers, config) {
        console.log(data);
      });
  }

  $scope.graphData = [
    {
      "Month": "Jan-11",
      "storeId": 1,
      "Sales": 14
    },{
      "Month": "Feb-11",
      "storeId": 1,
      "Sales": 14
    },{
      "Month": "March-11",
      "storeId": 1,
      "Sales": 17
    },{
      "Month": "Jan-11",
      "storeId": 2,
      "Sales": 14
    },{
      "Month": "Feb-11",
      "storeId": 2,
      "Sales": 16
    },{
      "Month": "March-11",
      "storeId": 2,
      "Sales": 8
    }
  ];

}]);
