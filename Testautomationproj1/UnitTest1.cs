using System;
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
        ///     This method is doing important work
        ///     for test method 02
        /// </summary>
        [TestMethod]
        [TestProperty("TestcaseID", "1072")]
        [TestCategory(TestHelpers.TestCategories.ApplicationVersion.V0404)]
        [TestCategory(TestHelpers.TestCategories.TestStatus.Active)]
        [TestCategory(TestHelpers.TestCategories.TestRun.Daily)]
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
        ///     something Important will happen in this 
        ///     test method02
        /// </summary>
        [TestMethod]
        [TestProperty("TestcaseID", "1073")]
        [TestCategory(TestHelpers.TestCategories.TestRun.Weekly)]
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
    }
}
