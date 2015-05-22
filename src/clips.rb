require 'launchpad'

interaction = Launchpad::Interaction.new(:device_name => "Launchpad S")

@home_path = "/Users/beth/Projects/launchpad/audio"

@clip_pids = Array.new
@clip_paths

def get_audio_clips
    @clip_paths = Dir["#{@home_path}/**/*.wav"]
end

def play(row, column)
    stop_other_audio

    clip = "#{@home_path}/#{row}_#{column}.wav"

    p "triggering #{clip}"
    pid = fork{ exec 'afplay', clip }

    @clip_pids << pid
end

def stop_other_audio
    @clip_pids.each do |pid|
        p "stopping #{pid}"
        Process.kill "TERM", pid
        Process.wait pid
    end

    @clip_pids = Array.new
end

def brightness(action)
  action[:state] == :down ? :off : :high
end

# yellow feedback for grid buttons
interaction.response_to(:grid) do |interaction, action|
  b = brightness action

  if (action[:state] == :down ) then
    #   p action
      play action[:x], action[:y]
  end

  if (action[:state] == :up ) then
      interaction.device.change :grid, action.merge(:green => b, :red => b)
  end
end

# red feedback for top control buttons
interaction.response_to([:up, :down, :left, :right, :session, :user1, :user2, :mixer]) do |interaction, action|
  interaction.device.change action[:type], :red => brightness(action)
end

# green feedback for scene buttons
interaction.response_to([:scene1, :scene2, :scene3, :scene4, :scene5, :scene6, :scene7, :scene8]) do |interaction, action|
  interaction.device.change action[:type], :green => brightness(action)
end

# mixer button terminates interaction on button up
interaction.response_to(:mixer, :up) do |interaction, action|
  interaction.stop
end

def button_has_clip?(row, column)
    false
end

(0..7).each do |x|
    (0..7).each do |y|
        if (button_has_clip? x, y) then
            interaction.device.change :grid, :x => x, :y => y, :red => :low, :green => :high
        else
            interaction.device.change :grid, :x => x, :y => y, :red => :high, :green => :low
        end
    end
end

#get all clips
get_audio_clips

# start interacting
interaction.start

# sleep so that the messages can be sent before the program terminates
sleep 0.1
