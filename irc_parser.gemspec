Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'irc_parser'
  s.version           = '0.0.1'
  s.date              = '2011-07-05'
  s.rubyforge_project = 'irc_parser'

  s.summary     = "Parses and generates IRC protocol messages."
  s.description = "Parses and generates IRC protocol messages."

  s.authors  = ["Emmanuel Oga"]
  s.email    = 'EmmanuelOga@gmail.com'
  s.homepage = 'http://github.com/emmanueloga'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc LICENSE]

  s.add_development_dependency('rspec', ["~> 2.0.0"])

  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.md
    Rakefile
    irc_parser.gemspec
    lib/irc_parser.rb
    lib/irc_parser/helper.rb
    lib/irc_parser/message.rb
    lib/irc_parser/message_class_config.rb
    lib/irc_parser/messages.rb
    lib/irc_parser/messages/commands.rb
    lib/irc_parser/messages/errors.rb
    lib/irc_parser/messages/replies.rb
    lib/irc_parser/params.rb
    lib/irc_parser/parser.rb
    lib/irc_parser/parser.rl
    spec/fixtures/from_weechat.rb
    spec/fixtures/inbound.log
    spec/irc_parser/helper_spec.rb
    spec/irc_parser/irc_parser_spec.rb
    spec/irc_parser/params_spec.rb
    spec/irc_parser/parser_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_1_password_message_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_2_nick_message_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_3_user_message_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_4_server_message_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_5_oper_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_6_quit_spec.rb
    spec/irc_parser/rfc1459/4_1_connection_registration/4_1_7_server_quit_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_1_join_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_2_part_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_3_1_channel_modes_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_3_2_user_modes_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_4_topic_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_5_names_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_6_list_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_7_invite_message_spec.rb
    spec/irc_parser/rfc1459/4_2_channel_operations/4_2_8_kick_command_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_1_version_message_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_2_stats_message_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_3_links_message_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_4_time_message_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_5_connect_message_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_6_trace_message_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_7_admin_command_spec.rb
    spec/irc_parser/rfc1459/4_3_server_queries_and_commands/4_3_8_info_command_spec.rb
    spec/irc_parser/rfc1459/4_4_sending_messages/4_4_1_private_messages_spec.rb
    spec/irc_parser/rfc1459/4_4_sending_messages/4_4_2_notice_spec.rb
    spec/irc_parser/rfc1459/4_5_user_based_queries/4_5_1_who_query_spec.rb
    spec/irc_parser/rfc1459/4_5_user_based_queries/4_5_2_whois_query_spec.rb
    spec/irc_parser/rfc1459/4_5_user_based_queries/4_5_3_whowas_spec.rb
    spec/irc_parser/rfc1459/4_6_miscellaneous_messages/4_6_1_kill_message_spec.rb
    spec/irc_parser/rfc1459/4_6_miscellaneous_messages/4_6_2_ping_message_spec.rb
    spec/irc_parser/rfc1459/4_6_miscellaneous_messages/4_6_3_pong_message_spec.rb
    spec/irc_parser/rfc1459/4_6_miscellaneous_messages/4_6_4_error_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_1_0_away_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_2_0_rehash_message_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_3_0_restart_message_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_4_0_summon_message_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_5_0_users_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_6_0_operwall_message_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_7_0_userhost_message_spec.rb
    spec/irc_parser/rfc1459/5_0_optionals/5_8_0_ison_message_spec.rb
    spec/irc_parser/rfc1459/6_0_replies/6_1_error_parsing_spec.rb
    spec/irc_parser/rfc1459/6_0_replies/6_2_command_responses_generation_spec.rb
    spec/irc_parser/rfc2812/5_1_command_responses/5_1_command_responses_spec.rb
    spec/spec_helper.rb
    spec/support/messages_helper.rb
    spec/support/simplecov.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec\/.+/ }
end
