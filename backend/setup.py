from setuptools import setup, find_packages

setup(
    name="agritrace",
    version="0.1.0",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        "django>=4.2.0",
        "djangorestframework>=3.14.0",
        "psycopg2-binary>=2.9.5",
        "python-dotenv>=1.0.0",
        "drf-yasg>=1.21.5",
        "django-cors-headers>=3.14.0",
        "djangorestframework-simplejwt>=5.2.2",
        "Pillow>=9.5.0",
    ],
    python_requires=">=3.8",
    author="AgriTrace Team",
    author_email="contact@agritrace.com",
    description="Agricultural supply chain traceability platform",
    keywords="agriculture, supply chain, traceability, farm",
    url="https://github.com/yourusername/AgriTrace",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Framework :: Django",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 3",
        "Topic :: Software Development :: Libraries",
    ],
)
