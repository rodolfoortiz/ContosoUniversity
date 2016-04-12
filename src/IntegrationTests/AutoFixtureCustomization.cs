using AutoFixture.AutoEF;
using ContosoUniversity.DAL;
using ContosoUniversity.DependencyResolution;

namespace ContosoUniversity.IntegrationTests
{
    using Ploeh.AutoFixture;
    using System.Web.Mvc;

    public abstract class AutoFixtureCustomization : ICustomization
    {
        public void Customize(IFixture fixture)
        {
            fixture.Customizations.Add(new IdOmitterBuilder());
            fixture.Customizations.Add(new OmitListBuilder());
            //fixture.Customize(new EntityCustomization(new DbContextEntityTypesProvider(typeof(SchoolContext))));

            CustomizeFixture(fixture);

            fixture.Behaviors.Remove(new ThrowingRecursionBehavior());
            fixture.Behaviors.Add(new OmitOnRecursionBehavior());
        }

        protected abstract void CustomizeFixture(IFixture fixture);
    }
}