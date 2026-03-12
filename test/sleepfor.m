function sleepfor(job)
logthis('sleeping for %i minutes...\n', job.minutes)
pause(job.minutes*60)
logthis('I''m up now!\n')
end