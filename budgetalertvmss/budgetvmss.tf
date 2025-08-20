terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_action_group" "main" {
  name                = "${var.prefix}-action-group"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "ag-${var.prefix}"
}

resource "azurerm_consumption_budget_resource_group" "main" {
  name              = "${var.prefix}-vmss-budget"
  resource_group_id = azurerm_resource_group.main.id

  amount     = 5000   # adjust your budget here
  time_grain = "Monthly"

  time_period {
    start_date = "2025-08-01T00:00:00Z"
    end_date   = "2025-12-31T00:00:00Z"
  }

  # Filter to only include the VMSS resource
  filter {
    dimension {
      name = "ResourceId"
      values = [
        azurerm_linux_virtual_machine_scale_set.main.id,
      ]
    }
  }

  notification {
    enabled        = true
    threshold      = 70.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_emails = [
      "arshad.jhs25@gmail.com"
    ]

    contact_groups = [
      azurerm_monitor_action_group.main.id,
    ]

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled   = true
    threshold = 100.0
    operator  = "GreaterThan"

    contact_emails = [
      "arshad.jhs25@gmail.com"
    ]
  }
}

