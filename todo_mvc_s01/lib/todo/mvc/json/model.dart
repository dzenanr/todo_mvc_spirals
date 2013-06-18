part of todo_mvc;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// rename dartling to yourDomainName
// rename Skeleton to YourModelName
// do not change model or Model

// lib/dartling/skeleton/json/model.dart

var todoMvcModelJson = r'''
{
    "width":990,
    "lines":[

    ],
    "height":580,
    "boxes":[
        {
            "entry":true,
            "name":"Task",
            "x":162,
            "y":147,
            "width":80,
            "height":80,
            "items":[
                {
                    "sequence":20,
                    "category":"required",
                    "name":"title",
                    "type":"String",
                    "essential":true,
                    "sensitive":false,
                    "init":""
                },
                {
                    "sequence":30,
                    "category":"required",
                    "name":"completed",
                    "type":"bool",
                    "essential":true,
                    "sensitive":false,
                    "init":"false"
                }
            ]
        }
    ]
}
''';