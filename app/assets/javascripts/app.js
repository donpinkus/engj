var myApp = angular.module('myApp', ['templates', 'ngMaterial', 'angular-dimple', 'ngRoute', 'ui.bootstrap']);

myApp.config(['$routeProvider', function($routeProvider) {
  $routeProvider
  .when('/', {
    templateUrl: 'pages/home.html',
    controller: 'home'
  })
  .when('/summary', {
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
  })
  .when('/compare', {
    templateUrl: 'pages/compare.html',
    controller: 'compare'
  })
}]);

myApp.directive('topNav', function(){
  return {
    templateUrl: 'top-nav.html'
  }
});

myApp.directive('skillTypeahead', ['$http', function($http){
  return {
    link: function(scope, data, attrs){
      scope.inputModel = attrs.inputModel;

      $http.get('/skills')
        .success(function(data, status, headers, config){

          var skills = JSON.parse(data.skills);

          var skillNames = $.map(skills, function(value, index) {
            return [value.name];
          });

          scope.skills = skillNames;
        });
    },
    templateUrl: 'skill-typeahead.html'
  }
}]);


myApp.controller('home', ['$scope', function($scope){

}]);

myApp.controller('summary', ['$scope', '$http', '$log', '$routeParams', function($scope, $http, $log, $routeParams){
  $scope.roleFilter = null;

  $scope.$watch('roleFilter', function(){
    console.log('role changed!');
    $http.get('/summary/' + $scope.roleFilter)
      .success(function(data, status, headers, config) {
        $scope.summary = data;
        $scope.skillFrequencies = JSON.parse(data["skill_frequencies"]);
        $scope.frequencyVsSalary = JSON.parse(data["frequency_vs_salary"]);
      })
      .error(function(data, status, headers, config) {
        console.log(data);
      });
  });

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
    $http.get('/skill_analyzer?skill_name=' + encodeURIComponent($scope.skill)).
      success(function(data, status, headers, config) {
        $scope.summary = data;
        $scope.bucketedSalaries = JSON.parse(data["salary_buckets"]);
        $scope.bucketedJobs = JSON.parse(data["new_jobs_by_month"])
        $scope.relatedSkills = JSON.parse(data["related_skills"]);
        console.log($scope.relatedSkills);
      }).
      error(function(data, status, headers, config) {
        console.log(data);
      });
  }
}]);



myApp.controller('compare', ['$scope', '$http', '$routeParams', function($scope, $http, $routeParams){
  $scope.compare = function(){
    $http.get('/compare?first_skill=' + $scope.firstSkill + '&second_skill=' + $scope.secondSkill).then(function(data){
      $scope.jobGrowth = JSON.parse(data.data.new_jobs_by_month);
    });
  }

}]);











