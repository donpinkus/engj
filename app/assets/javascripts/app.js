var myApp = angular.module('myApp', ['templates', 'ngMaterial', 'angular-dimple', 'ngRoute']);

myApp.config(function($routeProvider) {
  $routeProvider
  .when('/', {
    templateUrl: 'pages/summary.html',
    controller: 'summary'
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


// myApp.service('nameService', function(){
//   var self = this;

//   this.name = "John Doe";
//   this.nameLength = function(){
//     return self.name.length;
//   }
// });


myApp.controller('summary', ['$scope', '$http', '$log', '$routeParams', function($scope, $http, $log, $routeParams){
  $http.get('/summary')
    .success(function(data, status, headers, config) {
      $scope.summary = data;
      $scope.skillFrequencies = JSON.parse(data["skill_frequencies"]);
      $scope.frequencyVsSalary = JSON.parse(data["frequency_vs_salary"]);
    })
    .error(function(data, status, headers, config) {
      console.log(data);
    });
}]);


myApp.controller('skillAnalyzer', ['$scope', '$http', '$log', '$routeParams', function($scope, $http, $log, $routeParams){
  $scope.skill = $routeParams.skill || '';

  $scope.getSkillSummary = function() {
    $http.get('/skill_analyzer/' + $scope.skill).
      success(function(data, status, headers, config) {
        console.log(data);
        $scope.summary = data;
        $scope.bucketedSalaries = JSON.parse(data["salary_buckets"]);
        $scope.bucketedJobs = JSON.parse(data["new_jobs_by_month"])
        console.log($scope.bucketedSalaries);
      }).
      error(function(data, status, headers, config) {
        console.log(data);
      });
  }
}]);
