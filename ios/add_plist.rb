require 'xcodeproj'

project_path = '/Users/ndtltd/Desktop/pocketPlan/ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Verify if file is already added
target = project.targets.first
group = project.main_group.find_subpath('Runner', true)

# check if file already exists in group
existing_file = group.files.find { |f| f.path == 'GoogleService-Info.plist' }

unless existing_file
  puts 'Adding GoogleService-Info.plist to project...'
  file_ref = group.new_reference('GoogleService-Info.plist')
  target.add_file_references([file_ref])
  project.save
  puts 'Successfully added!'
else
  puts 'File already exists in project.'
end
