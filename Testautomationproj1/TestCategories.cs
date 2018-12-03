//--------------------------------------------------
// <copyright file="TestCategories.cs" company="Test">
//  Copyright 2018 Test, All rights Reserved
// </copyright>
// <summary>Assertions for test cases.</summary>
//--------------------------------------------------

namespace TestHelpers
{
    /// <summary>
    /// Classifications to apply to tests to enable filtering at run time.
    /// Example: [TestCategory(TestCategories.TestStatus.Active)]
    /// </summary>
    public static class TestCategories
    {
        /// <summary>
        /// Test status: Active, WIP or Hold
        /// </summary>
        public static class TestStatus
        {
            /// <summary>
            /// 'TestStatus-Active': Test is complete, include in test runs. 
            /// </summary>
            public const string Active = "TestStatus-Active";

            /// <summary>
            /// 'TestStatus-WIP': Work in progress (test is in development)
            /// </summary>
            public const string WIP = "TestStatus-WIP";

            /// <summary>
            /// 'TestStatus-Hold': On hold, exclude from test runs
            /// </summary>
            public const string Hold = "TestStatus-Hold";

            /// <summary>
            /// 'TestStatus-Watch': Run separately. Has had or can expect fails.
            /// </summary>
            /// <remarks>
            /// Added to segregate tests that have a history of fails from other tests.
            /// E.g. menu tests have had failures for new features which weren't fixed 
            /// promptly.
            /// </remarks>
            public const string Watch = "TestStatus-Watch";
        }

        /// <summary>
        /// Test run group (frequency): Smoke, Daily or Weekly
        /// </summary>
        public static class TestRun
        {
            /// <summary>
            /// Smoke test - part of a small group of tests to be run after deployments
            /// </summary>
            public const string Smoke = "TestRun-Smoke";

            /// <summary>
            /// Daily test - higher priority test to be run daily
            /// </summary>
            public const string Daily = "TestRun-Daily";

            /// <summary>
            /// Weekly test - lower priority test to be run weekly
            /// </summary>
            public const string Weekly = "TestRun-Weekly";

            /// <summary>
            /// Ad hoc test - run as needed
            /// </summary>
            public const string AdHoc = "TestRun-AdHoc";

            /// <summary>
            /// Gated health checks - run after each deployment, a test failure should fail the build
            /// </summary>
            public const string HealthCheckGating = "HealthCheck-Gating";

            /// <summary>
            /// Non-gating health checks - run after each deployment
            /// </summary>
            public const string HealthCheckNonGating = "HealthCheck-NonGating";
        }

        /// <summary>
        /// Application version group. E.g. 4.3, 4.4
        /// </summary>
        public static class ApplicationVersion
        {
            /// <summary>
            /// Application version 4.3
            /// </summary>
            public const string V0403 = "AppVersion-4.3";

            /// <summary>
            /// Application version 4.4
            /// </summary>
            public const string V0404 = "AppVersion-4.4";
        }
    }
}
