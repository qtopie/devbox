## ShortCut

* Perspective and views
```
Ctrl-F7 : switch between opened views
Ctrl-F8 : switch between perspectives
Alt-Shift Q Q : open a closed view
```

* Debug 
```
F5 F6 F7
```

* Run/Debug
```
Shift-F11/F11
```

* Test
```
Shift Alt X + T / F11
```

* Open Methods/Quick Outline view
```
Ctrl + O
```

* Create new file

```
Ctrl + N
```

* Refactor
```
Shift-Alt+R
```

* Search

```
Ctrl + F
```

* Navgiation

Go to line: `Ctrl + L`

Go to last edited: `Ctrl + Q`

Go to last/next visted: `Alt + <-/->`

Max/Min window: `Ctrl + M`

* Set author name with git user name 

Windows > Preferences > Java > Code Style > Code Templates > Comments -> Types , Edit
${author:git_config(user.name)}

## Gradle Eclipse

Eclipse default compiled classes is to `bin` folder, but gradle default to `build` folder, refer to `.classpath` file.
So we need to make eclipse point to right build output folder
 
Refer to issue: https://github.com/gradle/gradle/issues/3839

Workaround

```gradle
eclipse {
    classpath {
//        downloadJavadoc = true
  //      downloadSources = true

        defaultOutputDir = file('build/default')
        file.whenMerged {
            entries.each {
                source ->
                    // This seems kludgy.  If the second test is omitted, it fails processing a 'Project Dependency' entry
                    if (source.kind == 'src' && source.hasProperty('output')) {
                        def outputPath = source.output
                        switch(source.path) {
                            case 'src/main/java':
                              outputPath = 'build/classes/java/main'
                              break
                            case 'src/main/resources':
                              outputPath = 'build/resources/main'
                              break
                            case 'src/test/java':
                              outputPath = 'build/classes/java/test'
                              break
                            case 'src/test/resources':
                              outputPath = 'build/resources/test'
                              break
                        }

                        source.output = outputPath
                    }
            }
        }
    }
}
```
