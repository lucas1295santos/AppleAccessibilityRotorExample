# Custom Accessibility Rotor for iOS apps

In this article, I will teach how you, as a developer, how can you leverage Voice Over's power to improve your apps`s user experience for the blind and people with low vision, using the rotor.

Voice Over is the native iOS screen reader for visually impaired users. And one of its coolest features that allows its users to navigate through the system and apps with ease, is the rotor.

The rotor changes rules for exploring the screen space, by selecting items on the screen with a different logic; as well as enabling useful and customisable shortcuts through the system.

One exemple is showed bellow: the user enables the headings option on its rotor, allowing him to jump from header to header and easily find the desired content

[Rotor demonstration video on Youtube](https://www.youtube.com/watch?v=mv3zEP-iB-4)

For education purposes, we will create a ultra simple rotor option, that when enabled, allows the user to change a variable value and select the label that displays this value. The app filters results on the table view by a price filter, that the user controls with the voice over custom rotor "Filter Price"

[App demonstration video on Youtube](https://www.youtube.com/watch?v=pOue72FUYTY)

To create a custom rotor option for your application, you will use the UIAcessibilityCustomRotor object from UIKit framework. So, let us create a function that setup a rotor.

```
private func setupDistanceRotor() -> UIAccessibilityCustomRotor {

}
```

In this function, we will instantiate and return a UIAccessibilityCustomRotor passing 2 parameters on the init function.

**name**: will be read by Voice Over to the user, so it is important to be a clear and descriptive name for your action.

**closure**: this closure takes a predicate of type UIAccessibilityCustomRotorSearchPredicate as parameter, that gives you all the important info you need about the user interaction with your rotor option. And it expects a UIAccessibilityCustomRotorItemResult as result. This result object is mainly for direct Voice Over to wich object it should focus after the interaction.

```
let propertyRotorOption = UIAccessibilityCustomRotor.init(name: “Filter distance”) { (predicate) -> UIAccessibilityCustomRotorItemResult? in

}
return propertyRotorOption
```

Now inside this closure, we will extract some info from the predicate to know the swipe direction of the user.

```
let forward = predicate.searchDirection == UIAccessibilityCustomRotorDirection.next
```

If the user is doing a forward movement, we want to increase the value of our variable, and lower it with a backwards movement.

```
if forward {
self.searchDistance += 1
} else {
self.searchDistance -= 1
}
```

And them, we want to update this value to the label that displays the variable.

```
self.rotorPropertyValueLabel.text = String(self.searchDistance)
```

At last, we want to create that response object of type UIAccessibilityCustomRotorItemResult, and return it to the closure.


```
return UIAccessibilityCustomRotorItemResult.init(targetElement: self.rotorPropertyValueLabel , targetRange: nil)
```

As said before, this object specify to the rotor, wich object should be focused after the interaction. In this case, we want to focus the label that displays the value to the user.

And here is the full code for this setup function:

```
private func setupDistanceRotor() -> UIAccessibilityCustomRotor {
//Create a custor Rotor option, it has a name that will be read by voice over, and a action that is a
//action called when this rotor option is interacted with.
//The predicate gives you info about the state of this interaction
let propertyRotorOption = UIAccessibilityCustomRotor.init(name: “Filter distance”) { (predicate) -> UIAccessibilityCustomRotorItemResult? in
//Get the direction of the movement when this rotor option is enablade
let forward = predicate.searchDirection == UIAccessibilityCustomRotorDirection.next
//You can do any kind of business logic processing here
if forward {
self.searchDistance += 1
} else {
self.searchDistance -= 1
}
self.filterIceCreamList()
self.rotorPropertyValueLabel.text = String(self.searchDistance)
//Return the selection of voice over to the element rotorPropertyValueLabel
//Use this return to select the desired selection that fills the purpose of its logic
return UIAccessibilityCustomRotorItemResult.init(targetElement: self.rotorPropertyValueLabel , targetRange: nil)
}
return propertyRotorOption
}
```

The last thing we have to do, is to add this UIAccessibilityCustomRotor to the enabled rotors on our application. In this example, we will create the object with our function, and them add it to the array of self.accessibilityCustomRotors:

```
let distanceRotor = self.setupDistanceRotor()
self.accessibilityCustomRotors = [distanceRotor]
```

At this point, you can test the app with Voice Over on, and your custom rotor should be listed on the rotor menu. When selected, swipe up and down to change the variable value. No matter where you are on the screen, Voice Over selection will be directed to this label when you use this option.

This is a really simple example of custom rotor usage, but you can basically add any kind of business logic that makes sense for your application navigation, and make something really awesome!

### References:

[My Medium post](https://medium.com/@lucas1295santos/custom-accessibility-rotor-for-ios-apps-eca5aeb1eaa0)


[WWDC16 session](https://developer.apple.com/videos/play/wwdc2016/202/)

