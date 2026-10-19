package FreelanceDeskRequirements {
    doc /* Требования к веб-приложению FreelanceDesk (CRM-трекер для фрилансера). Версия 0.2. */

    import ScalarValues::*;

    // ---------- Участники и система ----------
    part def Freelancer;
    part def ExternalClient;
    part def MailServer;

    part def FreelanceDesk {
        part clientModule;
        part projectModule;
        part billingModule;
        part dashboardModule;
        part notificationModule;
        part securityModule;
    }

    // ---------- Базовые определения требований ----------
    requirement def FunctionalRequirement {
        attribute priority : String;   // MoSCoW: Must | Should | Could
        subject system : FreelanceDesk;
    }
    requirement def QualityRequirement {
        attribute metric : String;
        subject system : FreelanceDesk;
    }

    // ---------- Функциональные требования ----------
    requirement freelanceDeskSpec {
        doc /* Корневое требование: учёт клиентов, статусов проектов, дедлайнов, формирование счетов и актов. */

        requirement clientAccounting {
            requirement <'REQ-FUNC-002'> clientCards : FunctionalRequirement {
                doc /* Система должна позволять создавать, изменять, архивировать карточки клиентов. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-003'> search : FunctionalRequirement {
                doc /* Система должна выполнять поиск и фильтрацию клиентов и проектов. */
                attribute :>> priority = "Should";
            }
            requirement <'REQ-FUNC-009'> interactionLog : FunctionalRequirement {
                doc /* Система должна вести журнал взаимодействий с клиентом. */
                attribute :>> priority = "Should";
            }
        }

        requirement projectsAndDeadlines {
            requirement <'REQ-FUNC-004'> projectCards : FunctionalRequirement {
                doc /* Система должна позволять вести проекты клиента. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-005'> projectStatuses : FunctionalRequirement {
                doc /* Система должна контролировать допустимые переходы статусов и хранить их историю. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-006'> milestones : FunctionalRequirement {
                doc /* Система должна позволять задавать этапы проекта со сроками. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-007'> deadlineControl : FunctionalRequirement {
                doc /* Система должна выделять просроченные и приближающиеся сроки. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-014'> kanbanBoard : FunctionalRequirement {
                doc /* Система должна показывать проекты на доске статусов с перетаскиванием карточек. */
                attribute :>> priority = "Should";
            }
            requirement <'REQ-FUNC-015'> deadlineReminders : FunctionalRequirement {
                doc /* Система должна отправлять напоминания о сроках на e-mail. */
                attribute :>> priority = "Could";
            }
        }

        requirement billingDocuments {
            requirement <'REQ-FUNC-010'> invoiceCreation : FunctionalRequirement {
                doc /* Система должна формировать счёт с автоматической нумерацией. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-011'> actCreation : FunctionalRequirement {
                doc /* Система должна формировать акт выполненных работ. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-012'> pdfExport : FunctionalRequirement {
                doc /* Система должна выгружать счёт и акт в формате PDF. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-013'> invoiceStatuses : FunctionalRequirement {
                doc /* Система должна вести статусы счетов и отмечать просроченные. */
                attribute :>> priority = "Should";
            }
            requirement <'REQ-FUNC-016'> documentMailing : FunctionalRequirement {
                doc /* Система должна отправлять счёт и акт клиенту по e-mail. */
                attribute :>> priority = "Could";
            }
        }

        requirement overviewAndAccess {
            requirement <'REQ-FUNC-001'> authentication : FunctionalRequirement {
                doc /* Система должна обеспечивать регистрацию и вход фрилансера. */
                attribute :>> priority = "Must";
            }
            requirement <'REQ-FUNC-008'> dashboard : FunctionalRequirement {
                doc /* Система должна показывать сводку по проектам, срокам и оплатам. */
                attribute :>> priority = "Should";
            }
        }
    }

    // ---------- Требования к качеству (выборка) ----------
    requirement <'REQ-PERF-001'> pageResponse : QualityRequirement {
        doc /* Страница списка открывается не более чем за 1,5 с (95-й процентиль). */
        attribute :>> metric = "p95 <= 1.5 s";
    }
    requirement <'REQ-SEC-002'> dataIsolation : QualityRequirement {
        doc /* Пользователь получает доступ только к собственным данным. */
        attribute :>> metric = "0 чужих записей в выдаче";
    }
    requirement <'REQ-REL-002'> uniqueNumbering : QualityRequirement {
        doc /* Номера счетов и актов уникальны и идут без пропусков. */
        attribute :>> metric = "0 дублей";
    }

    // ---------- Распределение требований по модулям ----------
    part freelanceDesk : FreelanceDesk;

    satisfy clientCards by freelanceDesk.clientModule;
    satisfy projectStatuses by freelanceDesk.projectModule;
    satisfy milestones by freelanceDesk.projectModule;
    satisfy deadlineControl by freelanceDesk.projectModule;
    satisfy invoiceCreation by freelanceDesk.billingModule;
    satisfy actCreation by freelanceDesk.billingModule;
    satisfy pdfExport by freelanceDesk.billingModule;
    satisfy dashboard by freelanceDesk.dashboardModule;
    satisfy deadlineReminders by freelanceDesk.notificationModule;
    satisfy authentication by freelanceDesk.securityModule;
    satisfy dataIsolation by freelanceDesk.securityModule;

    // ---------- Варианты использования ----------
    use case def ManageClients {
        subject system : FreelanceDesk;
        actor user : Freelancer;
        objective { doc /* Вести базу клиентов и историю общения. */ }
    }
    use case def TrackProject {
        subject system : FreelanceDesk;
        actor user : Freelancer;
        objective { doc /* Вести проект: статусы, этапы, сроки. */ }
    }
    use case def IssueDocuments {
        subject system : FreelanceDesk;
        actor user : Freelancer;
        actor customer : ExternalClient;
        actor mail : MailServer;
        objective { doc /* Сформировать счёт или акт и передать клиенту. */ }
    }
}
