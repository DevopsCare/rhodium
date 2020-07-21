resource "aws_dynamodb_table" "rhodium_environments" {
  name           = "rhodium_environments"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "name"

  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "rhodium_schedules" {
  name           = "rhodium_schedules"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "name"

  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "rhodium_actions" {
  name           = "rhodium_actions"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "action_id"

  attribute {
    name = "action_id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "rhodium_schedule_weekdays_riga" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "riga-weekdays"},
      "timezone": {"S": "Europe/Riga"},
      "type": {"S": "regular"},
      "start_cron": {"S": "0 9 * * mon-fri"},
      "stop_cron": {"S": "0 19 * * mon-fri"}
    }
  ITEM
}

resource "aws_dynamodb_table_item" "rhodium_schedule_weekdays_new_york" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "new-york-weekdays"},
      "timezone": {"S": "EST"},
      "type": {"S": "regular"},
      "start_cron": {"S": "0 9 * * mon-fri"},
      "stop_cron": {"S": "0 19 * * mon-fri"}
    }
  ITEM
}

resource "aws_dynamodb_table_item" "rhodium_schedule_weekdays_new_york_plus_riga" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "new-york-plus-riga-weekdays"},
      "timezone": {"S": "utc"},
      "type": {"S": "regular"},
      "start_cron": {"S": "0 7 * * mon-fri"},
      "stop_cron": {"S": "0 0 * * mon-fri"}
    }
  ITEM
}

resource "aws_dynamodb_table_item" "rhodium_schedule_us_pacific" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "us-pacific"},
      "timezone": {"S": "US/Pacific"},
      "type": {"S": "regular"},
      "start_cron": {"S": "0 9 * * mon-fri"},
      "stop_cron": {"S": "0 19 * * mon-fri"}
    }
  ITEM
}

resource "aws_dynamodb_table_item" "rhodium_schedule_2h" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "stop-in-2h"},
      "timezone": {"S": "utc"},
      "type": {"S": "on_time"},
      "stop_in": {"S": "2h"}
    }
  ITEM
}

resource "aws_dynamodb_table_item" "rhodium_schedule_4h" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "stop-in-4h"},
      "timezone": {"S": "utc"},
      "type": {"S": "on_time"},
      "stop_in": {"S": "4h"}
    }
  ITEM
}

resource "aws_dynamodb_table_item" "rhodium_schedule_8h" {
  table_name = aws_dynamodb_table.rhodium_schedules.name
  hash_key   = aws_dynamodb_table.rhodium_schedules.hash_key

  item = <<-ITEM
    {
      "name": {"S": "stop-in-8h"},
      "timezone": {"S": "utc"},
      "type": {"S": "on_time"},
      "stop_in": {"S": "8h"}
    }
  ITEM
}
