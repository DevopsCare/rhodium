/*
* Copyright (c) 2020 Risk Focus Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

resource "aws_dynamodb_table" "rhodium_environments" {
  name         = "rhodium_environments"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"

  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "rhodium_schedules" {
  name         = "rhodium_schedules"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"

  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "rhodium_actions" {
  name         = "rhodium_actions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "action_id"

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
