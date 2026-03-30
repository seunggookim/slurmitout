function sleepfor(job)
logthis('sleeping for %i seconds...\n', job.seconds)
for i = 1:job.seconds
  pause(1)
  logthis('%i seconds passed... I''m still sleeping!\n', i)
end
logthis('I''m up now!\n')
end
