require 'cli/ui'

CLI::UI::StdoutRouter.enable

CLI::UI::Frame.open('{{*}} {{bold:a}}', color: :green) do
  CLI::UI::Frame.open('{{i}} b', color: :magenta) do
    CLI::UI::Frame.open('{{?}} c', color: :cyan) do
      sg = CLI::UI::SpinGroup.new
      sg.add('wow') do |spinner|
        sleep(2.5)
        spinner.update_title('second round!')
        sleep (1.0)
      end
      sg.add('such spin') { sleep(1.6) }
      sg.add('many glyph') { sleep(2.0) }
      sg.wait
    end
  end
  CLI::UI::Frame.divider('{{v}} lol')
  puts CLI::UI.fmt '{{info:words}} {{red:oh no!}} {{green:success!}}'
  sg = CLI::UI::SpinGroup.new
  sg.add('more spins') { sleep(0.5) ; raise 'oh no' }
  sg.wait
end
