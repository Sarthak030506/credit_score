import React, { useState } from 'react'
import { Layout } from '../components/common/Layout'
import { Card } from '../components/common/Card'
import { Button } from '../components/common/Button'
import { Alert } from '../components/common/Alert'

export default function AdminPanel({ user, onLogout }) {
    // Mock logs
    const [logs] = useState([
        { id: 1, action: 'Score Calculation', user: 'APP-001', status: 'Success', time: '10:42 AM' },
        { id: 2, action: 'Login Failed', user: 'unknown@test.com', status: 'Warning', time: '10:15 AM' },
        { id: 3, action: 'System Config Update', user: 'Admin', status: 'Success', time: '09:30 AM' },
    ])

    return (
        <Layout user={user} onLogout={onLogout}>
            <div className="flex justify-between items-center mb-8">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900">Admin Console</h1>
                    <p className="text-gray-500">System monitoring and auditing</p>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
                <div className="lg:col-span-3 space-y-8">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <Card title="System Health" className="border-l-4 border-l-green-500">
                            <div className="flex items-center space-x-2 text-green-600 font-bold">
                                <span className="h-3 w-3 bg-green-500 rounded-full animate-pulse"></span>
                                <span>Operational</span>
                            </div>
                            <p className="text-sm text-gray-500 mt-1">API Latency: 45ms</p>
                        </Card>
                        <Card title="Total Users" className="border-l-4 border-l-blue-500">
                            <div className="text-3xl font-bold text-gray-900">1,248</div>
                            <p className="text-sm text-gray-500 mt-1">+12% this week</p>
                        </Card>
                        <Card title="ML Model Status" className="border-l-4 border-l-purple-500">
                            <div className="text-purple-600 font-bold">v2.1.0 Active</div>
                            <p className="text-sm text-gray-500 mt-1">Last Retrain: 2h ago</p>
                        </Card>
                    </div>

                    <Card title="Recent System Activity">
                        <div className="overflow-x-auto">
                            <table className="min-w-full text-sm">
                                <thead className="bg-gray-50">
                                    <tr>
                                        <th className="px-4 py-3 text-left font-medium text-gray-500">Time</th>
                                        <th className="px-4 py-3 text-left font-medium text-gray-500">Action</th>
                                        <th className="px-4 py-3 text-left font-medium text-gray-500">User/Subject</th>
                                        <th className="px-4 py-3 text-left font-medium text-gray-500">Status</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-gray-100">
                                    {logs.map(log => (
                                        <tr key={log.id} className="hover:bg-gray-50">
                                            <td className="px-4 py-3 text-gray-500">{log.time}</td>
                                            <td className="px-4 py-3 font-medium text-gray-900">{log.action}</td>
                                            <td className="px-4 py-3 text-gray-600">{log.user}</td>
                                            <td className="px-4 py-3">
                                                <span className={`px-2 py-1 rounded-full text-xs font-semibold
                          ${log.status === 'Success' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}
                        `}>
                                                    {log.status}
                                                </span>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </Card>
                </div>

                <div className="space-y-8">
                    <Card title="Services Control">
                        <div className="space-y-3">
                            <Button className="w-full" variant="secondary">Restart API Service</Button>
                            <Button className="w-full" variant="secondary">Clear Cache</Button>
                            <Button className="w-full" variant="danger">Emergency Stop</Button>
                        </div>
                    </Card>

                    <Alert type="info" title="Maintenance Scheduled">
                        System maintenance is scheduled for Sunday at 2:00 AM UTC.
                    </Alert>
                </div>
            </div>
        </Layout>
    )
}
