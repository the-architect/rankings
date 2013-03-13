require 'pty'

def results(str)
  begin
    results = if str.include?('Finished in')
      str[str.rindex(/Finished in .* seconds/im)..-1].gsub(/\e\[(\d+)m/, '').match(%r/(\d+) examples?, (\d+) failures?/im)
    end

    failures  = results[2].to_i
    tests     = results[1].to_i

    [tests, failures]
  rescue Exception => e
    [0,0]
  end
end

def run(cmd)
  Process.kill(9, @pid) if @pid
  output = ''
  begin
    PTY.spawn(cmd) do |r, w, pid|
      @pid = pid
      begin
        r.each_char do |char|
          print char
          output.concat char
        end
      rescue Errno::EIO
      end
    end
  rescue PTY::ChildExited => e
    e.status.exitstatus
  rescue Exception => e
    puts e
  end
  @pid = nil

  results(output)
end

def growl(tests, failed)
  growlnotify = `which growlnotify`.chomp
  title = 'Watchr Test Results'
  message = '%d Tests, %d Tests Failed' % [tests, failed]
  base_dir = File.dirname(__FILE__)
  image = failed == 0 ? "#{base_dir}/watchr/passed.jpg" : "#{base_dir}/watchr/failed.jpg"
  severity = failed == 0 ? '-1' : '1'
  options = "-w -n Watchr --image '#{File.expand_path(image)}'"
  options << " -m '#{message}' '#{title}' -p #{severity}"
  system %(#{growlnotify} #{options} &)
end


def all_test_files(dir)
  Dir["#{dir}/**/*_spec.rb"]
end

def run_all_tests
  r1 = run("bundle exec rspec #{all_test_files('spec').join(' ')}")

  growl(r1[0], r1[1])
end


def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end
  puts "Running #{file}"
  result = run "bundle exec rspec #{file}"
  growl(result[0], result[1])
  puts
end

#######################################################

# RULES

watch('^spec/.*/*_spec.rb') { |match| run_spec match[0] }
watch('^app/(.*/.*).rb')    { |match| run_spec %{spec/#{match[1]}_spec.rb} }
watch('^lib/(.*/.*).rb')    { |match| run_spec %{spec/#{match[1]}_spec.rb} }

#######################################################

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1
    # raise Interrupt, nil # let the run loop catch it
    run_all_tests
    @interrupted = false
  end
end


run_all_tests