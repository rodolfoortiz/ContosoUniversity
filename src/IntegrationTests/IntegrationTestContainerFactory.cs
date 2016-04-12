﻿namespace ContosoUniversity.IntegrationTests
{
    using System;
    using DAL;
    using DependencyResolution;
    using StructureMap;

    public class IntegrationTestContainerFactory
    {
        private static readonly Lazy<InnerFactory> LazyInnerFactory = new Lazy<InnerFactory>(() => new InnerFactory());

        public static IContainer Container
        {
            get { return LazyInnerFactory.Value.Container; }
        }

        private class InnerFactory
        {
            public InnerFactory()
            {
                var container = IoC.Initialize();
                container.Configure(cfg => cfg.For<SchoolContext>().Use(() => new SchoolContext("Server=localhost;Database=ContosoUniversity;User Id=rortiz;Password=rortiz;")).Transient());
                Container = container;
            }

            public IContainer Container { get; private set; }
        }
    }
}