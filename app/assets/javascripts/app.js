var myApp = angular.module('myApp', ['templates', 'ngMaterial', 'angular-dimple', 'ngRoute']);

myApp.config(function($routeProvider) {
  $routeProvider
  .when('/', {
    templateUrl: 'pages/summary.html'
  })
  .when('/skill-analyzer', {
    templateUrl: 'pages/skill-analyzer.html',
    controller: 'skillAnalyzer'
  })
  .when('/skill-analyzer/:skill', {
    templateUrl: 'pages/skill-analyzer.html',
    controller: 'skillAnalyzer'
  });
});

myApp.service('nameService', function(){
  var self = this;

  this.name = "John Doe";
  this.nameLength = function(){
    return self.name.length;
  }
});

myApp.controller('skillAnalyzer', ['$scope', '$http', '$log', '$routeParams', function($scope, $http, $log, $routeParams){
  $scope.skill = $routeParams.skill || '';

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
