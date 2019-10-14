require 'pathname'
require 'json'

workflow_path = Pathname.new("workflows")
weather_path = Pathname.new("weather_files")
run_path = Pathname.new("run")
output_path = Pathname.new("output")

json = File.read(workflow_path+'workflow.osw')
obj = JSON.parse(json)

for i in Dir.glob(weather_path+'*.epw')
    filename = File.basename(i)
    basename = File.basename(i, ".epw")
    obj['weather_file'] = "weather_files/#{filename}"
    json = obj.to_json
    workflow_name = Pathname.new(workflow_path + basename).sub_ext('.osw')
    File.open(workflow_name, 'w') {
        |file| file.write(json)
    }
    # run_cmd = "openstudio --bundle_path /home/rohan/Documents/openstudio-workflow/bundle/ run --workflow #{workflow_name}"
    run_cmd = "openstudio --bundle_path /home/rohan/Documents/openstudio-workflow/bundle/ run --workflow #{workflow_name}"

    puts run_cmd
    system("#{run_cmd}")
    File.rename(run_path+'eplusout.sql', output_path + "eplusout#{basename}.sql")
end