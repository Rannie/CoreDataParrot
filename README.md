# CoreDataParrot
CoreData stack management and quick query language library. [Objective-C Version](https://github.com/Rannie/RHParrotData)


###Install
---

Clone this repo and drag "CoreDataParrot" folder into your project.

###Usage
---

####Setup Database

```
var momdURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
var storeURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, 	inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("ParrotData.sqlite")
ParrotDataAgent.setup(momdURL: momdURL!, storeURL: storeURL)
```


####Operator

```
var query = ParrotQuery(entity: "Person")
query.query("name", op: .PQEqual, "Kobe")	// name == 'Kobe' 
var result: AnyObject? = query.execute()	// @[personObjs]
```

####Function

```
var query = ParrotQuery(entity: "Person")
query.query("age", function: .PQAverage)	// average: age
var result: AnyObject? = query.execute()	// average number of age 
```

####Sort

```
var query = ParrotQuery(entity: "Person")
query.sort("age", ascending: true)			// false means descending
var result: AnyObject? = query.execute()
```

####Compound 

```
var queryAge = ParrotQuery(entity: "Person")
queryAge.query("age", op: .PQGreaterOrEqual, 20)

var queryName = ParrotQuery(entity: "Person")
queryName.query("name", op: .PQEqual, "Kobe")

var query = queryAge.and(queryName)			// also can use 'or','not'
var result: AnyObject? = query?.execute()
```

####Import

Use class *ParrotDataImporter*

```
func doImport(entity: String, primaryKey: String?, data: Array<AnyObject>, insertHandler: ((oriObj: AnyObject, dataObj: NSManagedObject) -> ())?, updateHandler: ((oriObj: AnyObject, dataObj: NSManagedObject) -> ())?)
```

####Query Result Controller

Use class *ParrotResultController*


###Operators and Functions
---

see [RHParrotData](https://github.com/Rannie/RHParrotData)


###LICENSE
---

The MIT License (MIT)

Copyright (c) 2015 Hanran Liu

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

