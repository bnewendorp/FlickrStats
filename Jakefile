/*
 * Jakefile
 * FlickrStats
 *
 * Created by Brandon Newendorp on March 12, 2011.
 * Copyright 2011 Amoniq LLC, All rights reserved.
 */

var ENV = require("system").env,
    FILE = require("file"),
    JAKE = require("jake"),
    task = JAKE.task,
    FileList = JAKE.FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug",
    OS = require("os");

app ("FlickrStats", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "FlickrStats.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("FlickrStats");
    task.setIdentifier("com.amoniq.FlickrStats");
    task.setVersion("1.0");
    task.setAuthor("Brandon Newendorp");
    task.setEmail("brandon @nospam@ newendorp.com");
    task.setSummary("FlickrStats");
    task.setSources((new FileList("**/*.j")).exclude(FILE.join("Build", "**")));
    task.setResources(new FileList("Resources/**"));
    task.setIndexFilePath("index.html");
    task.setInfoPlistPath("Info.plist");
    task.setNib2CibFlags("-R Resources/");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

task ("default", ["FlickrStats"], function()
{
    printResults(configuration);
});

task ("build", ["default"]);

task ("debug", function()
{
    ENV["CONFIGURATION"] = "Debug";
    JAKE.subjake(["."], "build", ENV);
});

task ("release", function()
{
    ENV["CONFIGURATION"] = "Release";
    JAKE.subjake(["."], "build", ENV);
});

task ("run", ["debug"], function()
{
    OS.system(["open", FILE.join("Build", "Debug", "FlickrStats", "index.html")]);
});

task ("run-release", ["release"], function()
{
    OS.system(["open", FILE.join("Build", "Release", "FlickrStats", "index.html")]);
});

task ("deploy", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Deployment", "FlickrStats"));
    OS.system(["press", "-f", FILE.join("Build", "Release", "FlickrStats"), FILE.join("Build", "Deployment", "FlickrStats")]);
    printResults("Deployment")
});

task ("desktop", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Desktop", "FlickrStats"));
    require("cappuccino/nativehost").buildNativeHost(FILE.join("Build", "Release", "FlickrStats"), FILE.join("Build", "Desktop", "FlickrStats", "FlickrStats.app"));
    printResults("Desktop")
});

task ("run-desktop", ["desktop"], function()
{
    OS.system([FILE.join("Build", "Desktop", "FlickrStats", "FlickrStats.app", "Contents", "MacOS", "NativeHost"), "-i"]);
});

function printResults(configuration)
{
    print("----------------------------");
    print(configuration+" app built at path: "+FILE.join("Build", configuration, "FlickrStats"));
    print("----------------------------");
}
