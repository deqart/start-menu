#ifndef START_MENU_H
#define START_MENU_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <qqml.h>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString resolvedIcon READ resolvedIcon CONSTANT)
    Q_PROPERTY(QVariantList applicationList READ applicationList NOTIFY applicationsChanged)
    QML_ELEMENT

public:
    explicit Backend(QObject *parent = nullptr);

    QString resolvedIcon() const { return m_resolved_icon; }
    QVariantList applicationList() const { return m_applications; }

    Q_INVOKABLE void launchApplication(const QString &exec_command);

    Q_INVOKABLE void shutdownDialog();
    Q_INVOKABLE void restartDialog();
    Q_INVOKABLE void logoutDialog();
    Q_INVOKABLE void lockScreen();

    void loadIcon();
    void loadApplications();

signals:
    void applicationsChanged();

private:
    QString m_resolved_icon;
    QVariantList m_applications;
};

#endif /* START_MENU_H */
