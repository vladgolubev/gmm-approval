Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "404_not_found"
  waitOn: ->
    Meteor.subscribe "links"

Router.before (->
    unless Meteor.userId()
      @redirect "userUnauthorized"
      @stop()
    GAnalytics.pageview()
    @next()
  ),
  except: [
    "userUnauthorized"
  ]

Router.route "/",
  name: "main"
Router.route "/userUnauthorized",
  name: "userUnauthorized"
Router.route "/new-link",
  name: "newLink"
Router.route "/post/:_id",
  name: "post"
  data: ->
    #Workaround. Links subscription doesn't work with pagination
    Meteor.call "getPostById", @params._id, (err, result) ->
      Session.set "viewingPost", result
    Session.get "viewingPost"
Router.route "/user/:_id",
  name: "userProfile"
  data: -> @params._id