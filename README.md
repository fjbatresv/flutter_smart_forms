# Smart Forms 
![pub points](https://badges.bar/smart_forms/pub%20points) ![pub points](https://badges.bar/smart_forms/likes) ![pub points](https://badges.bar/smart_forms/popularity)

The idea behind this package is a easy way to build and validate a form with especific field types.

## Examples

- [Normal Usage](example/main.dart)
- [Button Out](example/buttonOut.dart)

## Features

### Field Types

You have an **ENUM** which contains the available field types (I will add more progressively). The supported types are:

- Text
- Multiline
- Number
- Phone
- E-Mail
- URL

### Input Actions

You can handle the action to show on the key **enter** of the keyboard for each field. By now are supported only 3 actions:

- Next
- Done
- Auto (If you use this the plugin will decide considering if this is the last field or not);

### Buttons

In this plugin you can add two buttons that only require the label to show and will be rendered.

- Submit Button
- Reset Button

Now you can use your custom button and access to the state of the form including the validateForm, resetForm and the responseToMap methods.

## How it works

You need to generate to types of entitys.

1. Field Model

    This one contains all the parameters and settings that are available (by now) for the fields of the form. These are:

    - label: String (mandatory)
    - type (Use the enum [Types](lib/utils/enums.dart))
    - errorMessage: String
    - required: boolean
    - actions (Use the enum [Actions](lib/utils/enums.dart))
    - hint: String
    - validate: boolean
    - maxLength: int
    - password: boolean
    - readOnly: boolean

2. Form Model

    This is the base of the plugin and contain just a little variables:

    - name: String (mandatory)
    - submitButton: String (mandatory)
    - resetButton: String
    - fields: List of entitys of **Field Model**

## Return Statement

At the submit of the form you will get a return like this:

```json
{
    "form": "<name of the form submitted>",
    "values": {
        "<field label>": "<value obtained>"
    }
}
```