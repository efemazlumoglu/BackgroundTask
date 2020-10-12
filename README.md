# BackgroundTask
BGAppRefreshTask IOS

Testing on the simulator is out of the question, but you can force events to happen via the debugger when running the app on a real device.

Build and run your app and then background it to schedule the task. Bring the app to the foreground again. Then in Xcode, hit the pause button in the debugger.

Copy and paste this line into terminal area To simulate a receiving an event: 

e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.efemaz.fetch"] 

You can do it again and again to see all pokemons.

And to force an early termination of a task:

e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.efemaz.fetch"]

