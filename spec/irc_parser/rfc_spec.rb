require 'spec_helper'

describe IRCParser::RFC, "in general" do

  def with_channel_helpers(str)
    str.tap { |str| str.extend(IRCParser::RFC::ChannelHelpers) }
  end

  def with_nick_helpers(str)
    str.tap { |str| str.extend(IRCParser::RFC::NicknameHelpers) }
  end

  it "knows valid and invalid nick names" do
    with_nick_helpers("emmanuel").should be_valid_nick
    with_nick_helpers("1emmanuel").should_not be_valid_nick
  end

  it "knows valid and invalid channel names, and channel modes" do
    IRCParser::RFC::CHANNEL_PREFIXES.values.each do |prefix|
      with_channel_helpers("#{prefix}hola").should be_valid_channel_name
      with_channel_helpers("#{prefix}hola").should_not be_invalid_channel_name
    end

    with_channel_helpers("hola").should be_invalid_channel_name
    with_channel_helpers("hola").should_not be_valid_channel_name

    with_channel_helpers("+hola").should be_modeless_channel
    with_channel_helpers("#hola").should be_normal_channel
    with_channel_helpers("!hola").should be_safe_channel
    with_channel_helpers("&hola").should be_local_channel
  end
end
