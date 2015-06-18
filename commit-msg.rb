#!/usr/bin/env ruby
require 'net/http'
require 'json'

#CONFIG YOUR STUFF HERE
@in_development_issue_label = "em implementação"

@issues = 'https://api.github.com/adelinosegundo/gcm-bank/issues'
@issue_not_in_development_message = "MENSAGEM DE COMMIT INVÁLIDA: A issue referenciada não existe ou não está marcada como \"#{@in_development_issue_label}\"."

@issue_not_referenced_message = "MENSAGEM DE COMMIT INVÁLIDA: Uma issue deve ser referenciada em seu commit"

message_file = ARGV[0]
message      = File.read(message_file)
$regex       = /#(\d+)/

def get_issues
  uri = URI(@issues)

  JSON.parse(Net::HTTP.get(uri))
end

if $regex.match message
  number = message[/#(\d+)/]
  number = number[/(\d+)/]
  get_issues.each do |issue|

    labels = []

    issue['labels'].each do |label|
      labels << label["name"]
    end

    exit 0 if number == issue['number'].to_s && labels.include?(@in_development_issue_label)
  end
  puts @issue_not_in_development_message
  exit 1
else
  puts @issue_not_referenced_message
  exit 1
end
