﻿using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;

namespace Testautomationproj1
{
    /// <summary>
    /// Sample test class
    /// </summary>
    [TestClass]
    public class UnitTest1
    {
        private const string TestGroup = "Menu-Integration";

        /// <summary>
        /// Summary description for 
        /// TestMethod1
        /// <para>
        ///     This method is doing important work
        ///     for test method 01
        ///     </para>
        ///This Text is in the middle.
        ///<para>
        ///Another para text
        ///bla bla
        ///</para>
        ///This text at end
        /// </summary>
        [TestMethod]
        [TestProperty("TestcaseID", "1072")]
        [TestCategory(TestHelpers.TestCategories.ApplicationVersion.V0403)]
        [TestCategory(TestHelpers.TestCategories.TestStatus.Active)]
        [TestCategory(TestHelpers.TestCategories.TestRun.Weekly)]
        public void TestMethod1()
        {
            ChromeOptions option = new ChromeOptions();
            option.AddArgument("--start-maximized");
            IWebDriver driver = new ChromeDriver(option);           
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(30));
            driver.Navigate().GoToUrl("https://www.google.lk/");
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementToBeClickable(By.Name("q")));
            IWebElement textField = driver.FindElement(By.Name("q"));
            textField.SendKeys("Selenium");
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementToBeClickable(By.CssSelector("input[value='Google Search']")));
            IWebElement searchButton = driver.FindElement(By.CssSelector("input[value='Google Search']"));
            searchButton.Click();
            Assert.AreEqual(true, wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.TitleContains("Selenium - Google Search")));
            driver.Dispose();
        }

        /// <summary>
        /// New Summary description for 
        /// TestMethod2
        ///     This is the method that is doing testing for 
        ///     test method02 - modified 06
        /// </summary>
        /// <remarks>
        /// Sample List
        /// <list type="bullet">
        /// <item>
        ///  List item 1
        /// </item>
        ///<item><description>List Item 2</description></item>
        /// </list>
        /// </remarks>
        [TestMethod]
        [TestProperty("TestcaseID", "1073")]
        [TestCategory(TestHelpers.TestCategories.TestRun.Daily)]
        [TestCategory(TestHelpers.TestCategories.TestStatus.Active)]
        public void TestMethod2()
        {
            ChromeOptions option = new ChromeOptions();
            option.AddArgument("--start-maximized");
            IWebDriver driver = new ChromeDriver(option);
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(30));
            driver.Navigate().GoToUrl("https://www.google.lk/");
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementToBeClickable(By.Name("q")));
            IWebElement textField = driver.FindElement(By.Name("q"));
            textField.SendKeys("Selenium");
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementToBeClickable(By.CssSelector("input[value='Google Search']")));
            IWebElement searchButton = driver.FindElement(By.CssSelector("input[value='Google Search']"));
            searchButton.Click();
            Assert.AreEqual(true, wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.TitleContains("Selenium - Google Search")));
            driver.Dispose();
        }
        
         /// <summary>
        /// New Summary description for 
        /// TestMethod3
        ///     This is the method that is doing testing for 
        ///     test method03
        /// </summary>
        [TestMethod]        
        [TestProperty("TestcaseID", "1076")]
        [TestCategory(TestHelpers.TestCategories.TestRun.Daily)]
        [TestCategory(TestHelpers.TestCategories.TestStatus.Active)]
        public void TestMethod3()
        {
            ChromeOptions option = new ChromeOptions();
            option.AddArgument("--start-maximized");
            IWebDriver driver = new ChromeDriver(option);
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(30));
            driver.Navigate().GoToUrl("https://www.google.lk/");
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementToBeClickable(By.Name("q")));
            IWebElement textField = driver.FindElement(By.Name("q"));
            textField.SendKeys("Selenium");
            wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementToBeClickable(By.CssSelector("input[value='Google Search']")));
            IWebElement searchButton = driver.FindElement(By.CssSelector("input[value='Google Search']"));
            searchButton.Click();
            Assert.AreEqual(true, wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.TitleContains("Selenium - Google Search")));
            driver.Dispose();
        }
    }
}
