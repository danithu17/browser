#include <QString>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngineQuick/QtWebEngineQuick>
#include <QQmlContext>
#include "src/WebEngineHandler.h"

int main(int argc, char *argv[])
{
    QtWebEngineQuick::initialize();
    QGuiApplication app(argc, argv);

    // Register our C++ backend to QML
    qmlRegisterType<WebEngineHandler>("Aegis.Core", 1, 0, "PrivacyCore");

    QQmlApplicationEngine engine;
    
    const QUrl url(QStringLiteral("qrc:/resources/Main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
