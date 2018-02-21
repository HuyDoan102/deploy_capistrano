namespace :opcache do
	desc "Run opcache:reset task"
	task :reset do
		on roles(:web) do
			within release_path do
				execute :cachetool, 'opcache:reset --fcgi=127.0.0.1:9000'
				# execute :cachetool, 'opcache:reset --fcgi=/run/php/php7.0-fpm.sock'
			end
		end
	end
end