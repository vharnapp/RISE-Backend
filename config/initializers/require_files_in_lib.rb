# rubocop:disable Rails/FilePath
Dir[File.join(Rails.root, 'lib', '**', '*.rb')].each { |l| require l }
# rubocop:enable Rails/FilePath
