app = angular.module('baseApp', ['ngResource']);

app.config(function($routeProvider){
  $routeProvider
    .when('/', {
      templateUrl: 'templates/main.html',
      controller: 'mainCtrl'
    })
    .when('/next', {
      templateUrl: 'templates/next.html',
      controller: 'mainCtrl'
    })
});

app.controller('mainCtrl', function($scope, $resource, $location, $window){
  $scope.name = 'name1';
  $scope.people = [];
  $scope.savePerson = function() {
    $scope.people.push($scope.name);
    $scope.name = '';
  };
  $scope.getUsers = function(){
    var url = "/collection/nameage";
    var Users = $resource(url);
    $scope.users = Users.query();
  };
  $scope.gotoPage = function(){
    var url = "/next";
    $location.path(url);
    // $window.location.href = url;
  }
});