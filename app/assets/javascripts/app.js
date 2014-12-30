var test = angular.module('test', [ 'ngMaterial' ]);

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

}]);
