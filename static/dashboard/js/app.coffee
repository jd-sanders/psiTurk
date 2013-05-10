#  Filename: app.coffee
define [
      'jquery'
      'underscore'
      'backbone'
      'router'
      'models/ConfigModel'
      'models/AtAGlanceModel'
      'views/SidebarView'
      'views/ContentView'
      'text!templates/overview.html'
      'text!templates/sidebar.html'
    ],
    (
      $
      _
      Backbone
      Router
      ConfigModel
      AtAGlanceModel
      SidebarView
      ContentView
      OverviewTemplate
      SideBarTemplate
    ) ->

      # Prevent links from reloading the page
      events:
        'click a' : 'pushstateClick'
        'click li' : 'pushstateClick'

      pushstateClick: (event) ->
        event.preventDefault()

      initialize: ->
        #  Pass in our Router module and call it's initialize function
        Router.initialize()

        # Load at-a-glance model and data
        ataglance = new AtAGlanceModel
        ataglance.fetch async: false

        # Load and add content html
        overviewContentHTML = _.template(OverviewTemplate,
          input:
            balance: ataglance.get("balance"))
        $('#content').html(overviewContentHTML)

        # Load configuration model
        config = new ConfigModel

        # Load and add side bar html
        sideBarHTML = _.template(SideBarTemplate)
        $('#sidebar').html(sideBarHTML)
        sidebarView = new SidebarView(
          config: config
          ataglance: ataglance)
        sidebarView.initialize()

        # Load content view after html; req's ids to be present
        contentView = new ContentView()
        contentView.initialize()

        # Have run button listen for clicks and tell server to create HITS
        $('#run').on "click", ->
          $.ajax url: "/create_hit"
