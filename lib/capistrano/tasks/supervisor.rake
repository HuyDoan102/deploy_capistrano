namespace :supervisor do
	desc "Restart supervisord"
	task :restart do
		on roles(:web) do
			sudo "service supervisord restart"
		end
	end

end