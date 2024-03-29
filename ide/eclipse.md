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
  project.natures 'org.eclipse.buildship.core.gradleprojectnature'
  classpath {
    downloadJavadoc = true
    downloadSources = true

    // Just a workaround, but this issue should be fixed in gradle :<
    defaultOutputDir = file('build/default')
    def map = [
      'src/main/java' : 'build/classes/java/main',
      'src/main/resources': 'build/resources/main',
      'src/test/java': 'build/classes/java/test',
      'src/test/resources': 'build/resources/test'
    ]

    file.whenMerged {
      entries.each { source ->
        if (source.kind == 'src' && source.hasProperty('output')) {
          source.output = map.get(source.path) ?: defaultOutputDir
        }
      }
    }
  }
}
```

## Setup in Ubuntu 18.04

Snap store version has better integration with Ubuntu currently.

```bash
sudo snap install eclipse --classic
```

* Workaround for customize eclipse

Use locate `eclipse.desktop`, found

```
/snap/eclipse/40/eclipse.desktop
/snap/eclipse/40/meta/gui/eclipse.desktop
/var/lib/snapd/desktop/applications/eclipse_eclipse.desktop
```

Edit `/var/lib/snapd/desktop/applications/eclipse_eclipse.desktop` and change exec to 
```
Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/eclipse_eclipse.desktop /snap/bin/eclipse --launcher.ini $HOME/snap/eclipse/current/eclipse.ini -Dorg.eclipse.equinox.p2.reconciler.dropins.directory=$HOME/snap/eclipse/current/dropins %U
```

Then put dropins and eclipse.init into $HOME/snap/eclipse/current/

* https://wiki.eclipse.org/Equinox_p2_tests#Dropins_Reconciler
