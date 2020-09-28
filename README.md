# ph-schematron

ph-schematron is a Java library that validates XML documents via [ISO Schematron](http://www.schematron.com).
It is licensed under Apache 2.0 license.

Schematron is now also on GitHub: https://github.com/Schematron 
It offers several different possibilities to perform this task where each solution offers its own advantages and disadvantages that are outlined below in more detail. ph-schematron only supports ISO Schematron and no other Schematron version.
The most common way is to convert the source Schematron file to an XSLT script and apply this XSLT on the XML document to be validated. Alternatively ph-schematron offers a native implementation for the Schematron XPath binding which offers superior performance over the XSLT approach but can only be used, if the Schematron rules consist purely of XPath expressions and don't contain any XSLT.

Continue reading the **full documentation** at http://phax.github.io/ph-schematron/.

## Usage with Maven

The dependency for ph-schematron looks like this, replacing `x.y.z` with the latest version number:

```xml
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron</artifactId>
  <version>x.y.z</version>
</dependency>
```

It transitively contains [ph-commons](https://github.com/phax/ph-commons), [SLF4J](http://www.slf4j.org/) and [Saxon HE](http://saxon.sourceforge.net/).

# Maven plugin to convert Schematron to XSLT at build time

**The Maven plugin `ph-sch2xslt-maven-plugin` is deprecated since v5.0.9 - the goal was integrated into `ph-schematron-maven-plugin`**

Maven plugin to convert Schematron (SCH) to XSLT at compile time using [ph-schematron](https://github.com/phax/ph-schematron) as the converter.

The conversion of Schematron to XSLT is quite costly. That’s why this Maven plugin that does the conversion at build time. 

By default the plugin is run in the Maven lifecycle phase *generate-resources*. The basic configuration of the plugin in the `pom.xml` looks like this (inside the `<build>/<plugins>` element), replacing `x.y.z` with the latest version number.

```xml
<plugin>
  <groupId>com.helger.maven</groupId>
  <artifactId>ph-schematron-maven-plugin</artifactId>
  <version>x.y.z</version>
  <executions>
    <execution>
      <goals>
        <goal>convert</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

Up to and including version 5.0.8 the Maven artifact Id was different:

```xml
<plugin>
  <groupId>com.helger.maven</groupId>
  <artifactId>ph-sch2xslt-maven-plugin</artifactId>
  <version>5.0.8</version>
  <executions>
    <execution>
      <goals>
        <goal>convert</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

The possible configuration parameters are:
  * `schematronDirectory` - The directory where the Schematron files reside. Defaults to `${basedir}/src/main/schematron`.
  * `schematronPattern` - A pattern for the Schematron files. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will be converted. Files in the `schematronDirectory` and its subdirectories will be considered. Default is `**/*.sch`.
  * `xsltDirectory` - The directory where the XSLT files will be saved. Default is `${basedir}/src/main/xslt`.
  * `xsltExtension` - The file extension of the created XSLT files. Default is `.xslt`.
  * `overwriteWithoutQuestion` - Overwrite existing Schematron files without notice? If this is set to `false` than existing XSLT files are not overwritten. Default is `true`.
  * `phaseName` - Define the phase to be used for XSLT creation. By default the `defaultPhase` attribute of the Schematron file is used.
  * `languageCode` - Define the language code for the XSLT creation. Default is `null` which means English. Supported language codes are: cs, de, en, fr, nl.
  * `forceCacheResult` (since v.5.2.1) - Force the caching of results from SCH to XSLT.
  * `parameters` (since v5.0.2) - A map to provide custom parameter for the Schematron XSLTs (as in `allow-foreign`). Example:

```xml
<configuration>
  ...
  <parameters> 
    <allow-foreign>true</allow-foreign>
    <anything>else</anything>
  </parameters>    
  ...
</configuration>
```

# Maven plugin to validate XML instances against Schematron rules

Maven plugin to validate XML files against convert Schematron (SCH) at compile time using [ph-schematron](https://github.com/phax/ph-schematron) as the validator.

This plugin was introduced in version 4.2.0.

By default the plugin is run in the Maven lifecycle phase *process-resources*. The basic configuration of the plugin in the `pom.xml` looks like this (inside the `<build>/<plugins>` element), replacing `x.y.z` with the latest version number:

```xml
<plugin>
  <groupId>com.helger.maven</groupId>
  <artifactId>ph-schematron-maven-plugin</artifactId>
  <version>x.y.z</version>
  <executions>
    <execution>
      <goals>
        <goal>validate</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

The possible configuration parameters are:
  * `schematronFile` - The Schematron file to be applied. This parameter is mandatory.
  * `schematronProcessingEngine` - The Schematron processing engine to be used. Can be one of `pure` (pure implementation), `schematron` (Schematron to XSLT engine) and `xslt` (pre-compiled XSLT files available). Default is `pure`.
  * `xmlDirectory` - The directory where the XML files to be validated are contained. It is expected that the XML files in this directory match the Schematron rules. Either this parameter or `xmlErrorDirectory` parameter are mandatory.
  * `xmlIncludes` - A pattern for the XML files to be included. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will be validated. Files in the `xmlDirectory` and its subdirectories will be considered. Default is `**/*.xml`.
  * `xmlExcludes` - A pattern for the XML files to be excluded. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will **NOT** be validated. Files in the `xmlDirectory` and its subdirectories will be considered.
  * `svrlDirectory` - The directory where the SVRL (Schematron Validation Report Language) files will be saved. If this property is not specified, no SVRL files will be written. By default the name of the SVRL file corresponds to the XML file that is validated (defined by the parameters `xmlDirectory`, `xmlIncludes` and `xmlExcludes`) with the suffix `.svrl`.
  * `xmlErrorDirectory` (since v4.3.0) - The directory where the XML files to be validated are contained. It is expected that the XML files in this directory do **not** match the Schematron rules. Either this parameter or `xmlDirectory` parameter are mandatory.
  * `xmlErrorIncludes` (since v4.3.0) - A pattern for the erroneous XML files to be included. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will be validated. Files in the `xmlDirectory` and its subdirectories will be considered. Default is `**/*.xml`.
  * `xmlErrorExcludes` (since v4.3.0) - A pattern for the erroneous XML files to be excluded. Can contain Ant-style wildcards and double wildcards. All files that match the pattern will **NOT** be validated. Files in the `xmlDirectory` and its subdirectories will be considered.
  * `svrlErrorDirectory` (since v4.3.0) - The directory where the erroneous SVRL files will be saved. If this property is not specified, no SVRL files will be written. By default the name of the SVRL file corresponds to the XML file that is validated (defined by the parameters `xmlErrorDirectory`, `xmlErrorIncludes` and `xmlErrorExcludes`) with the suffix `.svrl`.
  * `phaseName` - Define the phase to be used for XSLT creation. By default the `defaultPhase` attribute of the Schematron file is used.
  * `languageCode` - Define the language code for the XSLT creation. Default is `null` which means English. Supported language codes are: cs, de, en, fr, nl.
  * `parameters` (since v5.0.2) - Custom attributes to be used for the SCH to XSLT conversion. This parameter takes only effect when using schematronProcessingEngine "schematron" or "xslt". By default no parameter is present.
  * `failFast` (since v5.0.5) - If multiple XML files are validated this parameter defines whether the execution should fail at the first error (value `true`) or at the end only (value `false`). The default value is `true`.
  * `forceCacheResult` (since v5.2.1) - Force the caching of results of the conversion from SCH to XSLT (the default is `false`)
  * `lenient` (since v5.4.1) - If enabled, old deprecated Schematron namespace URIs can be read. This only has an affect when used with the "pure" engine (the default is `false`)


# Maven plugin to preprocess Schematron files

Maven plugin to preprocess a Schematron file and write the resulting file to disk.

This plugin was introduced in version 5.0.9.

By default the plugin is run in the Maven lifecycle phase *generate-resources*. The basic configuration of the plugin in the `pom.xml` looks like this (inside the `<build>/<plugins>` element), replacing `x.y.z` with the latest version number:

```xml
<plugin>
  <groupId>com.helger.maven</groupId>
  <artifactId>ph-schematron-maven-plugin</artifactId>
  <version>x.y.z</version>
  <executions>
    <execution>
      <goals>
        <goal>preprocess</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

The possible configuration parameters are:
  * `sourceFile` - The source Schematron file to be preprocessed. This parameter is mandatory.
  * `targetFile` - The target (preprocessed) Schematron file to be written. This parameter is mandatory.
  * `overwriteWithoutNotice` - Overwrite existing Schematron files without notice? If this is set to `false` than existing Schematron files are not overwritten. The default value is `true`.
  * `keepTitles` - If this is set to `false` than `<title>` elements will be removed. The default value is `false`.
  * `keepDiagnostics` - If this is set to `false` than `<diagnostic>` elements will be removed. The default value is `false`.
  * `keepReports` - Should `<report>` elements be kept or should they be converted to `<assert>` elements? The default value is `false`.
  * `keepEmptyPatterns` - Should `<pattern>` elements without a single rule be kept or deleted? The default value is `false`.

# ph-schematron-validator

This submodule is a Java library.
It is a validator for Schematron definitions based on RelaxNG definition.

## Usage with Maven

Add the following to your pom.xml to use this artifact, replacing `x.y.z` with the latest version number:

```xml
<dependency>
  <groupId>com.helger</groupId>
  <artifactId>ph-schematron-validator</artifactId>
  <version>x.y.z</version>
</dependency>
```

# Ant tasks

Since ph-schematron 4.3.0 there is an Apache Ant task that enables you to validate XML files against Schematron rules.
As I'm not an Ant expert please forgive me if some of the explanations are not 100% accurate.
ph-schematron 5.0.0 adds a new task for preprocessing Schematron files. 

## Validate documents with Schematron (since 4.3.0)

### Declare the task

There is currently only one task:

```xml
<taskdef name="schematron" classname="com.helger.schematron.ant.Schematron" />
```

For this Ant Task to be available you need to include the `ph-schematron-ant-task` "JAR with dependencies" in your classpath.
Alternatively you can use the `classpath` attribute to reference a classpath that is defined internally in the build script.

A compiled version of the "JAR with dependencies" is [available at the Maven Central Repository](https://repo1.maven.org/maven2/com/helger/ph-schematron-ant-task/).

### Execute task

The validation itself looks like this:

```xml
  <target name="validate">
...
    <schematron schematronFile="sample_schematron.sch" expectSuccess="true">
      <fileset dir="xml">
        <include name="*.xml" />
        <exclude name="err*.xml" />
      </fileset>
    </schematron>
...
  </target>
```

Basically you declare the Schematron file (relative to the project's base directory),
define whether you expect a successful validation or failures,
and finally you name the XML files to be validated (as resource collections - e.g. Filesets).

The `schematron` element allows for the following attributes:
  * `File` **schematronFile** - The Schematron file to be used for validation
  * `String` **schematronProcessingEngine** - The internal engine to be used. Must be one of `pure`, `schematron` or `xslt`. The default is `schematron`. In v5.0.0 `sch` was added as an alias for `schematron`.
  * `File` **svrlDirectory** - An optional directory where the SVRL files should be written to.
  * `String` **phaseName** - The optional Schematron phase to be used. Note: this is only available when using the processing engine `pure` or `schematron`. For engine `xslt` this is not available because this was defined when the XSLT was created.
  * `String` **languageCode** - The optional language code to be used. Note: this is only available when using the processing engine `schematron`. For engine `xslt` this is not available because this was defined when the XSLT was created. Default is English (en). Supported language codes are: cs, de, en, fr, nl.
  * `boolean` **expectSuccess** - `true` to expect successful validation, `false` to expect validation errors. If the expectation is incorrect, the build will fail.
  * `boolean` **failOnError** (since v5.0.0) - `true` to break the build if an error occurred, `false` to continue with the following tasks on error. The default value is `true`.
  * `boolean` **failOnValidationError** (since v5.0.11) - `true` to break the build, if any Schematron error is reported. This setting has lower precedence than `expectSuccess`. The default value is `false`.
  * `boolean` **failOnValidationWarn** (since v5.0.11) - `true` to break the build, if any Schematron warning is reported. This setting has lower precedence than `expectSuccess`. The default value is `false`.
  * `boolean` **failOnValidationInfo** (since v5.0.11) - `true` to break the build, if any Schematron information is reported. This setting has lower precedence than `expectSuccess`. The default value is `false`.

The following child elements are allowed:
* `<errorRole>` (since v5.0.2)
    * The usage of the element is optional.
    * The `role` attribute allows to define values of `role` and `flag` attributes in Schematrons that are considered as errors.
    * If this element is combined with the `failOnError` attribute you can break the build if an assertion with the respective `role` or `flag` fails.
* `<parameter>` (since v5.0.6)
    * The usage of the element is optional.
    * The element is only interpreted for the processing engines `xslt` and `sch`.
    * The attribute 'name' defines the custom attribute name.
    * The attribute 'value' defines the custom attribute value. If the value is omitted, an empty String is passed instead. 
  
Additionally you can use an `XMLCatalog` that acts as an Entity and URI resolver both for the Schematron and the XML files to be validated! See https://ant.apache.org/manual/Types/xmlcatalog.html for details on the XML catalog. Here is an example that shows how to use an inline XML catalog:

```xml
  <target name="validate">
    <schematron schematronFile="../sch/test.sch" 
                expectSuccess="true"
                schematronProcessingEngine="pure">
      <fileset dir=".">
        <include name="test.xml" />
      </fileset>
      <xmlcatalog>
        <dtd publicId="-//bla//DTD XML test//EN" location="../dtd/test.dtd"/>
      </xmlcatalog>
      <errorRole role="fatal" />
      <parameter name="allow-foreign" value="true" />
    </schematron>
  </target>
```


## Preprocess a Schematron file (since 5.0.0)

### Declare the task

There is currently only one task:

```xml
<taskdef name="schematron-preprocess" classname="com.helger.schematron.ant.SchematronPreprocess" />
```

For this Ant Task to be available you need to include the `ph-schematron-ant-task` "JAR with dependencies" in your classpath.
Alternatively you can use the `classpath` attribute to reference a classpath that is defined internally in the build script.

### Execute task

The validation itself looks like this:

```xml
  <target name="validate">
...
    <schematron-preprocess srcFile="src.sch" dstFile="dst.sch" />
...
  </target>
```

Basically you define source and destination Schematron files and that's it.
Additionally you can define a few settings controlling the output.

The `schematron` element allows for the following attributes:
  * `File` **srcFile** - The source Schematron file to be preprocessed. This parameter is required.
  * `File` **dstFile** - The destination file in which the preprocessed content should be written. This parameter is required.
  * `boolean` **keepTitles** - `true` to keep `&lt;title&gt;`-elements, `false` to delete them. Default is `false`.
  * `boolean` **keepDiagnostics** - `true` to keep `&lt;diagnostic&gt;`-elements, `false` to delete them. Default is `false`.
  * `boolean` **keepReports** - `true` to keep `&lt;report&gt;`-elements, `false` to change them to `&lt;assert&gt;`-elements. Default is `false`.
  * `boolean` **keepEmptyPatterns** - `true` to keep `&lt;pattern&gt;`-elements without rules, `false` to delete them. Default is `true`.
  * `boolean` **failOnError** - `true` to break the build if an error occurred, `false` to continue with the following tasks on error.


## News and noteworthy

* v5.6.3 - 2020-09-28
    * Extended SchematronResourceXSLT API (see [PR #107](https://github.com/phax/ph-schematron/pull/107)) - thanks [@jw3](https://github.com/jw3)
* v5.6.2 - 2020-09-17
    * Updated to Jakarta JAXB 2.3.3
* v5.6.1 - 2020-08-30
    * Updated to Saxon-HE 10.2
    * Updated to ant 1.10.8
* v5.6.0 - 2020-03-29
    * Updated to Saxon-HE 10.0
    * Changed the internal error handler to use `IError` and therefore also improve the error handling quality
    * Updated to ph-commons 9.4.0
* v5.5.0 - 2020-03-08
    * Updated to Saxon-HE 9.9.1-7
    * Improved XPath configuration for the pure Schematron implementation (see [PR #98](https://github.com/phax/ph-schematron/pull/98)) - thanks [@aanno](https://github.com/aanno)
        * See new interface `IXPathConfig` and builder class `XPathConfigBuilder` 
* v5.4.1 - 2020-03-08
    * Updated to Saxon-HE 9.9.1-6
    * Added a "lenient" setting to the pure Schematron implementation to allow reading Schematrons with an old namespace URI (see [PR #97](https://github.com/phax/ph-schematron/pull/97)) - thanks [@aanno](https://github.com/aanno)
    * Added the "lenient" flag to the Maven plugin for validating documents
* v5.4.0 - 2019-11-29
    * Changed the package of the generated SVRL classes from `org.oclc.purl.dsdl.svrl` to `com.helger.schematron.svrl.jaxb` to avoid incompatibilities with other Schematron solutions (incompatible change)
    * Removed `ph-sch2xslt-maven-plugin` which was deprecated long time ago. Use `ph-schematron-maven-plugin` instead.
* v5.3.0 - 2019-11-22
    * The default include handler of the pure version, now allows to include non-Schematron XMLs
    * Updated to Saxon-HE 9.9.1-5
    * The Maven plugin `preprocess` Mojo now emits the XML declaration as well
    * Added support for the Schematron query bindings `xpath` and `xpath2` ([issue #80](https://github.com/phax/ph-schematron/issues/80))
    * Updated to ANT 1.10.7
    * Extended API of `SCHTransformerCustomizer` for forcing result caching ([issue #87](https://github.com/phax/ph-schematron/issues/87)), added new parameters in Maven plugin and ANT task for this setting (`forceCacheResult`)
    * Renamed method `IPSValidationHandler.onRule` to `onFiredRule` (incompatible change)
    * Added methods `IPSValidationHandler.onRuleStart` and `and` for chaining
* v5.2.0 - 2019-06-13
    * Fixed a ClassLoader issues for ANT task ([issue #78](https://github.com/phax/ph-schematron/issues/78))
    * Updated the SVRL XSD with the ISO Schematron 2016 changes (incompatible change)
* v5.1.1 - 2019-06-12
    * Fixed regression in ANT task (see [issue #71](https://github.com/phax/ph-schematron/issues/71))
* v5.1.0 - 2019-06-11
    * Fixed created Schematron XSDs ([issue #76](https://github.com/phax/ph-schematron/issues/76))
    * Updated to ANT 1.10.6
    * Updated to Saxon-HE 9.9.1-3
    * Improved logging results in ANT task ([issue #71](https://github.com/phax/ph-schematron/issues/71))
    * Added new ANT task parameters `failOnValidationError`, `failOnValidationWarn` and `failOnValidationInfo` that all default to `false` ([issue #50](https://github.com/phax/ph-schematron/issues/50))
    * Removed deprecated methods
    * SCH and XSLT based compilers now correctly pass the `URIResolver` to the created XSLT - important for include resolution ([issue #77](https://github.com/phax/ph-schematron/issues/77))
    * The default include resolver was improved for file based SCH and XSLT validation
* v5.0.10 - 2019-05-07
    * Improved handling of XML elements from other namespaces ([issue #51](https://github.com/phax/ph-schematron/issues/51))
    * The Maven preprocess goal now uses the `<ns>` elements from the Schematron as XML namespace context
    * The ANT task is now build against 1.10.x but is source compatible with ANT 1.9.x
    * Added Java 12 support for Maven plugins
* v5.0.9 - 2019-04-25
    * Updated to Saxon-HE 9.9.1-1
    * Updated to ant 1.9.14
    * The Maven plugin `ph-sch2xslt-maven-plugin` is now deprecated and will be removed in the next major version. The functionality was moved "as-is" to the `ph-schematron-maven-plugin`
    * The Maven plugin `ph-schematron-maven-plugin` got a new goal `preprocess` to create preprocessed Schematrons ([issue #75](https://github.com/phax/ph-schematron/issues/75))
* v5.0.8 - 2018-11-26
    * Fixed an initialization error in the SCH to XSLT maven plugin in JDK 11
* v5.0.7 - 2018-11-22
    * Updated to Saxon-HE 9.9.0-1
    * Updated to ph-commons 9.2.0
* v5.0.6 - 2018-09-09
    * The Ant task has the possibility to provide custom parameters to XSLT and SCH validations ([issue #62](https://github.com/phax/ph-schematron/issues/62))
    * Instances of `SchematronResourceSCH` now have a default URI resolver to resolve references relative to the source Schematron
    * Requires ph-commons 9.1.5
    * `SVRLHelper` can now handle `null` inputs
* v5.0.5 - 2018-08-13
    * Added support to disable "fail fast" mode in ph-schematron-maven-plugin (see [issue #69](https://github.com/phax/ph-schematron/issues/69))
    * Updated to Saxon-HE 9.8.0-14
    * Fixed custom error handling for `report` when using `role` (see [issue #66](https://github.com/phax/ph-schematron/issues/66) again)
* v5.0.4 - 2018-05-14
    * Really fixed OSGI ServiceProvider configuration
    * Updated to Saxon-HE 9.8.0-12
* v5.0.3 - 2018-05-09
    * Fixed OSGI ServiceProvider configuration
* v5.0.2 - 2018-04-12
    * Added new interface `ISchematronXSLTBasedResource` as a common base class for XSLT based validations
    * Improved the `DefaultSVRLErrorLevelDeterminator` implementation to be more flexible and cater for more error levels
    * Updated to Saxon-HE 9.8.0-11
    * The Maven plugins now require Maven 3.0
    * Added new parameter `parameters` to the `ph-sch2xslt-maven-plugin`
    * Finally the `role` attribute is copied to a failed assertion when using the pure implementation
    * The Ant task has the possibility to provide values for `role` and `flag` that are interpreted as error ([issue #66](https://github.com/phax/ph-schematron/issues/66))
* v5.0.1 - 2018-02-01
    * Moved `getBeautifiedLocation` to class `SVRLHelper` and made it public
    * Updated to Saxon-HE 9.8.0-7
    * Requires ph-commons 9.0.1
* v5.0.0 - 2018-01-02
    * Updated to ph-commons 9.0.0
    * Added new ANT task for preprocessing Schematron files only
    * Improved support for `base-uri()` XPath function when using the pure implementation ([issue #47](https://github.com/phax/ph-schematron/issues/47))
    * Fixed issue with `role` attribute in SVRL when using pure implementation ([issue #54](https://github.com/phax/ph-schematron/issues/54))
    * Updated to Saxon-HE 9.8.0-6 - therefore no XLST v1 scripts can be used anymore - this only works up to 9.7.x!
    * Added ANT task property `failOnError` ([issue #57](https://github.com/phax/ph-schematron/issues/57))
* v4.3.4 - 2017-07-27
    * Added new class `SchematronDebug` that centrally manages the debug flags for logging etc. 
* v4.3.3 - 2017-07-27
    * Reverted to Saxon-HE 9.7.0_18 because of incompatibilities in production
* v4.3.2 - 2017-07-25
    * Updated to Saxon-HE 9.8.0-3
    * Changed all XSLT scripts to use and create only XSLT 2.0 (because Saxon 9.8.x does not support XSLT 1.0 anymore)
    * Updated to ph-commons 8.6.6
* v4.3.1 - 2017-05-29
    * Updated to ph-commons 8.6.5
    * Fixed too verbose logging of created XSLT
    * Removed some old deprecated methods
* v4.3.0 - 2017-05-15
    * Updated to Saxon-HE 9.7.0-18
    * Fixed an error with nested SVRL directories in Maven plugin ([issue #37](https://github.com/phax/ph-schematron/issues/37))
    * Added possibility to use "negative" tests in Maven plugin ([issue #38](https://github.com/phax/ph-schematron/issues/38))
    * Added ANT plugin to validate Schematron resources ([issue #39](https://github.com/phax/ph-schematron/issues/39), [issue #40](https://github.com/phax/ph-schematron/issues/40))
    * Using the EntityResolver also for the XML files to be validated (not just the Schematron)
    * Added a default `EntityResolver` and a default `URIResolver` that tries to resolve includes relative to the base Schematron.
* v4.2.2 - 2017-02-22
    * Updated to Saxon-HE 9.7.0-15
    * Fixed usage of `<let>` in `<extend>`-based rules for the pure implementation ([issue #36](https://github.com/phax/ph-schematron/issues/36))
* v4.2.1 - 2017-01-20
    * Added WrappedCollectingPSErrorHandler
* v4.2.0 - 2017-01-09
    * Binds to ph-commons 8.6.0
    * Updated to Saxon-HE 9.7.0-14
    * Added a new Schematron validation Maven plugin
* v4.1.1 - 2016-11-03
    * Added possibility to use XML EntityResolver ([issue #30](https://github.com/phax/ph-schematron/issues/30))
    * Updated to Saxon-HE 9.7.0-10
* v4.1.0 - 2016-09-09
    * Binding to ph-commons 8.5.x
* v4.0.2 - 2016-07-22
* v4.0.1 - 2016-07-05
    * better integration of sch2xslt Maven plugin into m2e - thanks to @baerrach
* v4.0.0 - 2016-06-15
    * updated to JDK8
    * updated to Saxon-HE 9.7
* v3.0.1 - 2015-10-14
    * keep diagnostics in Pure version; resource resolving emits to error handler
* v3.0.0 - 2015-07-29
    * because of update to ph-commons 6.0.0; extended XSLT based API 
* v2.9.2 - 2015-03-12
    * because of update to ph-commons 5.6.0 
* v2.9.1 - 2015-02-03
    * fixes a classloader issue added in 2.9.0
* v2.9.0 - 2015-01-30
    * introduced new APIs in several places
    * updated to Saxon-HE 9.6
* v2.8.4 - 2014-10-30    
* v2.8.3 - 2014-09-16
    * An easy way to use XQuery functions (like funcx library) as custom XPath functions was added
* v2.8.2 - 2014-09-02
* v2.8.1 - 2014-08-29
* v2.8.0 - 2014-08-28

---

My personal [Coding Styleguide](https://github.com/phax/meta/blob/master/CodingStyleguide.md) |
On Twitter: <a href="https://twitter.com/philiphelger">@philiphelger</a> |
Kindly supported by [YourKit Java Profiler](https://www.yourkit.com)
