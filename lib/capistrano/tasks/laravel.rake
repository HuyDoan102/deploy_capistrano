include Comparable

namespace :laravel do

  desc "Execute a provided artisan command."
  task :artisan, [:command_name] do |_t, args|
    ask(:cmd, "list") # Ask only runs if argument is not provided
    command = args[:command_name] || fetch(:cmd)

    on roles fetch(:laravel_roles) do
      within release_path do
        execute :php, :artisan, command, *args.extras, fetch(:laravel_artisan_flags)
      end
    end

    # Enable task artisan to be ran more than once
    Rake::Task["laravel:artisan"].reenable
  end

  desc "Run Artisan migrate task"
  task :migrate do
    on roles(:web) do
      within release_path do
        execute :php, 'artisan migrate', '--force'
      end
    end
  end

  desc "Rollback the last database migration."
  task :migrate_rollback do
    laravel_roles = fetch(:laravel_roles)
    laravel_artisan_flags = fetch(:laravel_artisan_flags)

    set(:laravel_roles, fetch(:laravel_migration_roles))
    set(:laravel_artisan_flags, fetch(:laravel_migration_artisan_flags))

    Rake::Task["laravel:artisan"].invoke("migrate:rollback")

    set(:laravel_roles, laravel_roles)
    set(:laravel_artisan_flags, laravel_artisan_flags)
  end

  desc "Create Storage directories & Set permissions task"
  task :permissions do
    on roles(:web) do
      within release_path do
      execute :chmod, '-R 777 public'
      execute :chmod, '-R 777 bootstrap'
      execute :chmod, '-R 777 storage'
      end
    end
  end

end