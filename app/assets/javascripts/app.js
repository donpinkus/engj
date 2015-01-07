var test = angular.module('test', ['templates', 'ngMaterial', 'angular-dimple', 'ngRoute']);

test.config(function($routeProvider) {
  $routeProvider
  .when('/', {
    templateUrl: 'pages/summary.html',
    controller: 'summary'
  })
  .when('/second', {
    templateUrl: 'pages/second.html'
  });
});

test.controller('summary', ['$scope', '$http', '$log', function($scope, $http, $log){

  $scope.getSkillSummary = function() {
    $http.get('/summary/' + $scope.skill).
      success(function(data, status, headers, config) {
        $scope.summary = data;
        $scope.bucketedSalaries = JSON.parse(data["salary_buckets"]);
        $scope.bucketedJobs = JSON.parse(data["new_jobs_by_month"])
      }).
      error(function(data, status, headers, config) {
        console.log(data);
      });
  }
}]);
