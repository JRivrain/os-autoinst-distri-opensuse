# Declarative Schedule

## Introduction

This is the documentation for declarative scheduling of test modules
which allows testers to schedule existing test modules in a more flexible way replacing main.pm mechanism.
However it is still work-in-progress due to it missing some features to be a full working solution
to replace it.

## Contents

* [Overview](#overview)
* [Getting started](#getting-started)
  * [1. Create declarative schedule](#1-create-declarative-schedule)
    * [_name_](#name)
    * [_description_](#description)
    * [_vars_](#vars)
    * [_conditional_schedule_](#conditional_schedule)
    * [_schedule_](#schedule)
  * [2. Enable scheduler in settings](#2-enable-scheduler-in-settings)
  * [3. Enable scheduler in main file](#3-enable-scheduler-in-main-file)
* [Other uses](#other-uses)

## Overview

 Declarative schedule is using a [YAML](https://en.wikipedia.org/wiki/YAML) file to specify all the information related with a test suite:
 - Test suite name and description
 - Test variables
 - Sequence of test modules

## Getting started

Prerequisites to use this mechanism are the following:

### 1. Create declarative schedule

The file to be created should look as follows:
```yaml
name:           test_suite_name
description:    >
    Test suite description.
    Further info about the test suite
vars:
    setting1_string: value1
    setting2_num: 2
    setting3_string: value3
    ...
conditional_schedule:
    module1:
        VAR1:
            <valueA>:
                - path/to/module/moduleA1
                - path/to/module/moduleA2
            <valueB>:
                - path/to/module/moduleB1
    ...

schedule:
    - {{module1}}
    - path/to/module/module2
    ...
```
Previous structure contains the following sections:

#### name
Name of the test suite

#### description
Description of the test suite.

#### vars
Most of your settings could be migrated from openQA WebUI to this declarative way, for instance:
  - `BOOTFROM: c`
  - `BOOT_HDD_IMAGE: 1`

There are a few exceptions:
  - `DESKTOP`: it produces wrong .json in openQA WebUI
  - `HDD_1`: if added, openQA will not publish the image in openQA WebUI due to it depends on os-autoinst.
  - `START_AFTER_TEST`: if added, openQA will not link dependencies on the corresponding tab in openQA WebUI due to it depends on os-autoinst.

#### conditional_schedule
Depending on different values of an environmental variable we can schedule different set of modules.
For instance, depending on the value of DISTRI setting we can schedule an ordered sequence of different tests for openSUSE or SLE.

```yaml
  conditional_schedule:
      addons_repos:
          DISTRI:
              opensuse:
                  - installation/online_repos
                  - installation/installation_mode
                  - installation/logpackages
              sle:
                  - installation/scc_registration
                  - installation/addon_products_sle
                  - installation/addon_products_sle
```

#### schedule
Refers to a sequence of test modules to be executed in the test suite. For the moment it was chosen this format `{{}}`
to indicate that the module or modules executed at this position is conditional to some variable as described in [conditional_schedule](#conditional_schedule).

**NOTE:**
 - [conditional_schedule](#conditional_schedule) does not allow at the moment to represent complex logic like combination of 'and' or 'or' and it does intend to do it due to potentially it would create the same problem that occurs with main.pm. Other kind of logic like a simple exclusion list could be feasible in the near future, for example "run for all except when this variable value is set to some specific value". Reusing of blocks needs to be re-thinked as well and what would be a readable syntax for this. At the moment if the scenario you intend to migrate has complex conditional logic it would require changes in your test modules.
 - The only section that is mandatory is [schedule](#schedule). The rest of the sections in the YAML file can be skipped.

### 2. Enable scheduler in settings

It is required to add in openQA WebUI in the test suite configuration a new setting `YAML_SCHEDULE` pointing to .yaml file path, for instance:
`YAML_SCHEDULE=schedule/test-suite-name.yaml`


### 3. Enable scheduler in main file

This functionality needs to be imported in corresponding main.pm for your product.
Only if `YAML_SCHEDULE` setting is set, information contained in .yaml file will be loaded and
execution of main.pm will be exited earlier and in turn the old main.pm mechanism will not be executed.
It is recommended to call the function after all variables have been set in main.pm.
 ```perl
 use scheduler 'load_yaml_schedule';
...
return 1 if load_yaml_schedule;
```

## Other uses

Even if you don't intend to migrate your scenario right now, you can play with it for debugging proposes. Instead of relying in the complex path of execution that main.pm creates, if you just need to put some test in some particular order, perhaps a new scenario you just created, you can speed up your development using this approach.
