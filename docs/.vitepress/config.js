      import { defineConfig } from 'vitepress'

      export default defineConfig({
        // Site metadata
        title: 'OpenRemote Rails API',
        description: 'API documentation auto-generated from Rails components and test examples',
        lang: 'en-US',

        // Routing
        base: '/',

        // Build configuration
        outDir: '../public',
        cacheDir: '.vitepress/cache',
        ignoreDeadLinks: false,

        // Theming
        appearance: true,
        lastUpdated: true,

        // Theme configuration
        themeConfig: {
          nav: [
    { text: 'Home', link: '/' },
    { text: 'Models', link: '/api/models/' },
    { text: 'Controllers', link: '/api/controllers/' },
    { text: 'Services', link: '/api/services/' },
    { text: 'Jobs', link: '/api/jobs/' },
    { text: 'Concerns', link: '/api/concerns/' },
    { text: 'Examples', link: '/examples/' }
  ],
          sidebar: {
      '/api/models/': [
        { text: 'Ability', link: '/api/models/ability' },
        { text: 'Ability::Base', link: '/api/models/ability/base' },
        { text: 'Ability::RoleDetector', link: '/api/models/ability/role_detector' },
        { text: 'Asset', link: '/api/models/asset' },
        { text: 'AssetType', link: '/api/models/asset_type' },
        { text: 'DataPoint', link: '/api/models/data_point' },
        { text: 'DataPoint::Analytics', link: '/api/models/data_point/analytics' },
        { text: 'Notification', link: '/api/models/notification' },
        { text: 'Role', link: '/api/models/role' },
        { text: 'Rule', link: '/api/models/rule' },
        { text: 'Rule::Execution', link: '/api/models/rule/execution' },
        { text: 'RuleExecution', link: '/api/models/rule_execution' },
        { text: 'UniqueIdentifierGenerator', link: '/api/models/unique_identifier_generator' },
        { text: 'User', link: '/api/models/user' },
        { text: 'ValueUtil', link: '/api/models/value_util' }
      ],
      '/api/controllers/': [
        { text: 'ConfirmationsController', link: '/api/controllers/confirmations_controller' },
        { text: 'DocsController', link: '/api/controllers/docs_controller' },
        { text: 'PasswordsController', link: '/api/controllers/passwords_controller' },
        { text: 'RegistrationsController', link: '/api/controllers/registrations_controller' },
        { text: 'SessionsController', link: '/api/controllers/sessions_controller' },
        { text: 'UnlocksController', link: '/api/controllers/unlocks_controller' }
      ],
      '/api/services/': [
        { text: 'AssetDatapointService', link: '/api/services/asset_datapoint_service' },
        { text: 'AssetProcessingService', link: '/api/services/asset_processing_service' },
        { text: 'JsonSchemaUtil', link: '/api/services/json_schema_util' },
        { text: 'LockByKey', link: '/api/services/lock_by_key' },
        { text: 'PseudoClock', link: '/api/services/pseudo_clock' },
        { text: 'RuleManager', link: '/api/services/rule_manager' },
        { text: 'SimulatorSchedule', link: '/api/services/simulator_schedule' }
      ],
      '/api/jobs/': [
        { text: 'ApplicationJob', link: '/api/jobs/application_job' },
        { text: 'DatapointCleanupJob', link: '/api/jobs/datapoint_cleanup_job' },
        { text: 'RuleExecutionJob', link: '/api/jobs/rule_execution_job' },
        { text: 'RuleManagerJob', link: '/api/jobs/rule_manager_job' }
      ],
      '/api/concerns/': [
        { text: 'Admin', link: '/api/concerns/admin' },
        { text: 'Assets', link: '/api/concerns/assets' },
        { text: 'Mapping', link: '/api/concerns/mapping' },
        { text: 'User::Confirmable', link: '/api/concerns/user/confirmable' },
        { text: 'User::Lockable', link: '/api/concerns/user/lockable' },
        { text: 'User::Recoverable', link: '/api/concerns/user/recoverable' },
        { text: 'User::Rememberable', link: '/api/concerns/user/rememberable' },
        { text: 'User::Seedable', link: '/api/concerns/user/seedable' }
      ],
      '/examples/': [
        { text: 'Ability', link: '/examples/ability' },
        { text: 'AbilityModules', link: '/examples/abilitymodules' },
        { text: 'ApplicationController', link: '/examples/applicationcontroller' },
        { text: 'Asset', link: '/examples/asset' },
        { text: 'AssetAttributeModules', link: '/examples/assetattributemodules' },
        { text: 'AssetDatapointService', link: '/examples/assetdatapointservice' },
        { text: 'AssetProcessingService', link: '/examples/assetprocessingservice' },
        { text: 'AssetType', link: '/examples/assettype' },
        { text: 'AssetTypeAttributes', link: '/examples/assettypeattributes' },
        { text: 'AssetTypeDispatch', link: '/examples/assettypedispatch' },
        { text: 'Assets', link: '/examples/assets' },
        { text: 'AttributeNormalization', link: '/examples/attributenormalization' },
        { text: 'ConfirmationsController', link: '/examples/confirmationscontroller' },
        { text: 'DataPoint', link: '/examples/datapoint' },
        { text: 'DataPointAnalyticsEdgeCases', link: '/examples/datapointanalyticsedgecases' },
        { text: 'DatapointCleanupJob', link: '/examples/datapointcleanupjob' },
        { text: 'DocsController', link: '/examples/docscontroller' },
        { text: 'JsonSchemaUtil', link: '/examples/jsonschemautil' },
        { text: 'LockByKey', link: '/examples/lockbykey' },
        { text: 'Mapping', link: '/examples/mapping' },
        { text: 'Notification', link: '/examples/notification' },
        { text: 'PasswordsController', link: '/examples/passwordscontroller' },
        { text: 'PseudoClock', link: '/examples/pseudoclock' },
        { text: 'RegistrationsController', link: '/examples/registrationscontroller' },
        { text: 'Rule', link: '/examples/rule' },
        { text: 'RuleExecution', link: '/examples/ruleexecution' },
        { text: 'RuleExecutionActions', link: '/examples/ruleexecutionactions' },
        { text: 'RuleExecutionCompareValues', link: '/examples/ruleexecutioncomparevalues' },
        { text: 'RuleExecutionJob', link: '/examples/ruleexecutionjob' },
        { text: 'RuleManager', link: '/examples/rulemanager' },
        { text: 'RuleManagerJob', link: '/examples/rulemanagerjob' },
        { text: 'SessionsController', link: '/examples/sessionscontroller' },
        { text: 'SimulatorSchedule', link: '/examples/simulatorschedule' },
        { text: 'UniqueIdentifierGenerator', link: '/examples/uniqueidentifiergenerator' },
        { text: 'UnlocksController', link: '/examples/unlockscontroller' },
        { text: 'User', link: '/examples/user' },
        { text: 'UserMailer', link: '/examples/usermailer' }
      ]
          }
        }
      })
