# Repalce the dashboardHeader 
dashboardHeader(
  title = "Gene Expression"
, # We need comma after the title as we will add another option
  #
  # ==== Messages Menu =======================================
  dropdownMenu(
    type = "messages",
    messageItem(
      from = "The Other Side",
      message = "I'll leave that up to you.",
      href = "http://coursera.org/search?query=rhyme",
      icon = icon("user"),  # Try another icon: 'question', 'life-ring'
      time = "13:31")       # Try different date/time format '2020-4-29', '2020-4-29 01:45'

    # , # If you add one more messageItem you need one more comma!

  ),

  # ==== Tasks Menu ==========================================
  dropdownMenu(
    type = "tasks",
    badgeStatus = "success",
    # Other badgeStatus are 'primary', 'success', 'info', 'warning', 'danger', NULL.

    taskItem(
      value = 92,
      color = "green",
      text = "Documentation")
    ,
    taskItem(
      value = 75,
      color = "yellow",
      text = "Sequencing")
    ,
    taskItem(
      value = 17,
      color = "aqua",
      text = "Project X"
    ),

    taskItem(
      value = 19,
      color = "red",
      text = "Known Interaction Network")
  ),

  # ==== Notifications menu ==================================
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "5 new users today",
      icon = icon("users"),
      status = "success"
    ),

    notificationItem(
      text = "12 items delivered",
      icon = icon("truck"),
      status = "success"
    ),
    notificationItem(
      text = "Server load at 86%",
      icon = icon("exclamation-triangle"),
      status = "warning"
    )
  ),

  # ====  Message Menu filled by server function =============
  dropdownMenuOutput("messageMenu")
)
