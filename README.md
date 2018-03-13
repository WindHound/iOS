# iOS Map  
  
Map page for iOS app

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

To download

```
$ cd dir
$ git pull origin
```

You will also need to use

```
Xcode 9.2 (9C40b)
Command line tools for Xcode 9.2
```

Might work on older Xcode but since Swift 4 is required 9.0 is the oldest supported version


### iOS Version

The code was tested on iPhone 6 and newer with iOS (10, 10.3.1 and 11.1) 

```
iOS 10.0
iOS 10.3.1
iOS 11.1
```

### Coding style

Try and have max 100 characters per line. Makes it easier to work with the Assistant editor

```
Preferences > Text Editing > Page guide at column: 100
```

Function defs are lower camel case; Classes and Extensions are upper camel case

Please use width 4 soft tabs and adhere to the NASA SOFTWARE ENGINEERING LABORATORY SERIES SEL-94-003 C STYLE GUIDE (http://homepages.inf.ed.ac.uk/dts/pm/Papers/nasa-c-style.pdf). Something like this:

``` 
int total;
int func1(void)
{
float total;
}
```

## Deployment

Current deployment target is 

```
iOS 10.3
```

The device type is set to Universal. Before we deploy, we need to integrate it

## Built With

* LLVM LTO (FINAL RELEASE)
* LLVM VECTORIZATION (FINAL RELEASE)

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests.

## Authors

* **Matei Sterian** - *Initial work* - [Grakkus](https://github.com/Grakkus)

* **David Shin** - *Edits and Additions* - [Dongnamu](https://github.com/Dongnamu)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Future Work

* Issues:       MKPolyline not always rendering  
*               Map resize and drag on smaller devices  
*  
* Nice to have: UI  
