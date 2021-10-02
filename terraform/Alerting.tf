
/*resource "azurerm_monitor_action_group" "critical_action_group" {
  name                = "CriticalAlertsAction"
  resource_group_name = azurerm_resource_group.hub.name
  short_name          = "critag"

  email_receiver {
    name          = "Email-Critical-Alert"
    email_address = "privera@10thmagnitude.com"
  }

  /*  itsm_receiver {
    name                 = "createorupdateticket"
    workspace_id         = "6eee3a18-aac3-40e4-b98e-1f309f329816"
    connection_id        = "53de6956-42b4-41ba-be3c-b154cdf17b13"
    ticket_configuration = "{}"
    region               = "southcentralus"
  } */

  /*sms_receiver {
    name         = "SMS-Critical-Alert"
    country_code = "1"
    phone_number = "4075627523"
  }
  /* 
  voice_receiver {
    name         = "remotesupport"
    country_code = "86"
    phone_number = "13888888888"
  } */

#}


/*resource "azurerm_monitor_action_group" "warning_action_group" {
  name                = "WarningAlertsAction"
  resource_group_name = azurerm_resource_group.hub.name
  short_name          = "warnag"

  email_receiver {
    name          = "Email-Warning-Alert"
    email_address = "privera@10thmagnitude.com"
  }

  /*  itsm_receiver {
    name                 = "createorupdateticket"
    workspace_id         = "6eee3a18-aac3-40e4-b98e-1f309f329816"
    connection_id        = "53de6956-42b4-41ba-be3c-b154cdf17b13"
    ticket_configuration = "{}"
    region               = "southcentralus"
  } */

  /*sms_receiver {
    name         = "SMS-Warning-Alert"
    country_code = "1"
    phone_number = "4075627523"
  }
  /* 
  voice_receiver {
    name         = "remotesupport"
    country_code = "86"
    phone_number = "13888888888"
  } */

#}