require 'json'

module Supper
  class Summary
    MAX_AGE = 604800
    TIME_FORMAT = '%F %l:%M%P'

    def summarize
      recent = get_recent_logs
      run_count = recent.count
      puts "#{run_count} logs since #{max_age_ago}"

      error_logs = get_logs_with_errors recent
      error_count = error_logs.count

      if error_count > 0
        puts "#{error_count} errors:"
        summarize_errors error_logs
        successes = recent.count - error_count
        puts "#{successes} successful runs"
      else
        puts 'no errors'
      end
    end

    def get_recent_logs
      get_recent_log_files.map do |file|
        JSON.parse File.read( file )
      end
    end

    def get_recent_log_files
      files = Dir.glob File.join( Dir.pwd, 'log/*.json' )
      files.select do |file|
        File.mtime(file) > Time.now - 604800
      end
    end

    def get_logs_with_errors logs
      logs.select do |log|
        log['error']
      end
    end

    def summarize_errors logs
      message_counts = {}

      logs.map do |log|
        message = log['error']['message']
        if message_counts[message]
          message_counts[message] += 1
        else
          message_counts[message] = 1
        end
      end

      message_counts.each do |message, count|
        puts "#{message} (#{count} times)"
      end
    end

    def max_age_ago
      (Time.now - MAX_AGE).strftime TIME_FORMAT
    end
  end
end
